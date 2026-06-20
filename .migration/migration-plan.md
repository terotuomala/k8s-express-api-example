# Migration Plan

## Context
- run_id: run-20260620-032937
- repo: terotuomala/k8s-express-api-example
- source: https://github.com/terotuomala/k8s-express-api-example
- namespace_target: atlas-prod
- complexity_score: 2.4 / 5 (LOW-MEDIUM)
- generated_at: 2026-06-20T16:26:00Z

## Component Scope

| Component | Status | Notes |
|---|---|---|
| api | in-scope | Node.js/Express service; Dockerfile present; Kustomize base+staging manifests in k8s/ |
| web | not_observed | No frontend artifact detected in this repository; out of scope |
| redis | dependency | Operational runtime dependency via ioredis; must be provisioned in atlas-prod before API deploy |
| github-api | external-integration | Outbound HTTP via axios to GITHUB_API_URL; egress policy must permit traffic |

## Evidence Base
- package.json: express@5, ioredis@5, axios@1, helmet@8, cors@2, dotenv@17, pino@10, @godaddy/terminus@4
- Dockerfile: present at repo root (production image build ready)
- K8s manifests: 11 files across k8s/base and k8s/staging (deployment, service, ingress, HPA, PDB, netpol-ingress, netpol-egress, kustomization)
- Env vars required (no defaults observed): GITHUB_API_URL, REDIS_DEFAULT_EXPIRATION; PORT defaults to 3001
- Integration edges: express_api → redis (ioredis), express_api → github_api (axios)
- API endpoints: GET /, GET /readyz, GET /livez

## Blocking Prerequisites

| Item | Status | Notes |
|---|---|---|
| GITHUB_API_URL value | required | No default; must be injected via Secret or ConfigMap |
| REDIS_DEFAULT_EXPIRATION value | required | No default; must be set before cache logic executes |
| Redis host/port | required | Referenced in src/api/index.js; not observed in env-mapping |
| atlas-prod namespace | required | K8s target must exist before apply |
| Container registry credentials | required | Image push must succeed before deploy |

## Migration Phases

### Phase 1 — Environment Preparation (Effort: 0.5 day)

**Objective:** Provision namespace, Redis, and all required Secrets/ConfigMaps before any workload is applied.

**Prerequisites:** GKE cluster accessible; kubectl + kustomize available; registry credentials configured.

**Tasks:**

| ID | Task | Effort | Go/No-Go Criteria |
|---|---|---|---|
| P1-1 | Create atlas-prod namespace | 0.25h | `kubectl get ns atlas-prod` returns exists |
| P1-2 | Provision Redis in atlas-prod (StatefulSet or external managed) | 2h | redis-cli ping from within cluster returns PONG |
| P1-3 | Create Secret with GITHUB_API_URL, REDIS_DEFAULT_EXPIRATION, REDIS_HOST, REDIS_PORT | 0.5h | `kubectl get secret k8s-express-api-secret -n atlas-prod` returns secret |
| P1-4 | Verify netpol-egress permits outbound to github_api_url host (port 443) | 0.5h | curl from test pod to GITHUB_API_URL returns HTTP 200/304 |
| P1-5 | Verify netpol-ingress permits ingress controller traffic to port 3001 | 0.25h | kubectl describe netpol shows ingress source selector matches ingress class |

**Rollback Trigger:** Redis provisioning fails or network policy blocks egress — do not proceed to Phase 2.

---

### Phase 2 — Container Image Build and Push (Effort: 0.5 day)

**Objective:** Build production-tagged container image from existing Dockerfile and push to registry.

**Prerequisites:** Phase 1 complete; registry credentials available.

**Tasks:**

| ID | Task | Effort | Go/No-Go Criteria |
|---|---|---|---|
| P2-1 | Clone repo at target commit SHA | 0.1h | Git SHA logged |
| P2-2 | Build image: `docker build -t <registry>/k8s-express-api-example:<sha> .` | 0.5h | Build exits 0 |
| P2-3 | Scan image for vulnerabilities (Trivy or equivalent) | 0.5h | 0 CRITICAL vulnerabilities |
| P2-4 | Push image to registry; record digest | 0.25h | `docker pull <registry>/k8s-express-api-example:<sha>` succeeds |

**Rollback Trigger:** Image build or push fails after 2 retries — investigate Dockerfile or registry auth.

---

### Phase 3 — Kubernetes Manifest Configuration (Effort: 0.5 day)

**Objective:** Create atlas-prod Kustomize overlay; patch image tag and namespace; validate manifests before apply.

**Prerequisites:** Phase 2 complete; image digest available.

**Tasks:**

| ID | Task | Effort | Go/No-Go Criteria |
|---|---|---|---|
| P3-1 | Create k8s/atlas-prod/ overlay based on k8s/staging/ | 0.5h | Directory and kustomization.yaml created |
| P3-2 | Patch kustomization.yaml with image digest from Phase 2 | 0.25h | `kustomize build k8s/atlas-prod/` renders without error |
| P3-3 | Patch namespace.yaml → atlas-prod | 0.1h | Namespace field updated |
| P3-4 | Validate HPA minReplicas is consistent with PDB minAvailable | 0.25h | No conflict — PDB allows at least 1 disruption |
| P3-5 | Dry-run server-side apply: `kubectl apply -k k8s/atlas-prod/ --dry-run=server` | 0.25h | Exit 0; no validation errors |

**Rollback Trigger:** Dry-run returns admission webhook errors or schema violations — fix manifests before proceeding.

---

### Phase 4 — Deployment to atlas-prod (Effort: 1 day)

**Objective:** Apply workload to atlas-prod; verify pods reach Running+Ready; confirm ingress assignment.

**Prerequisites:** Phases 1–3 complete.

**Tasks:**

| ID | Task | Effort | Go/No-Go Criteria |
|---|---|---|---|
| P4-1 | Apply: `kubectl apply -k k8s/atlas-prod/` | 0.25h | Command exits 0 |
| P4-2 | Watch rollout: `kubectl rollout status deployment/k8s-express-api-example -n atlas-prod --timeout=300s` | 0.5h | Exit 0 within 5 min |
| P4-3 | Verify all pods Running+Ready; no CrashLoopBackOff | 0.25h | `kubectl get pods -n atlas-prod` shows all Ready=1/1 |
| P4-4 | Confirm readiness probe passing (/readyz) via pod describe events | 0.25h | No probe failure events in last 2 min |
| P4-5 | Confirm ingress address assigned | 0.25h | `kubectl get ingress -n atlas-prod` shows non-empty ADDRESS |

**Rollback Trigger:** Rollout fails to complete within 5 min, or pods show CrashLoopBackOff — execute `kubectl rollout undo deployment/k8s-express-api-example -n atlas-prod`.

---

### Phase 5 — Smoke Tests (Effort: 0.5 day)

**Objective:** Validate all three API endpoints and Redis cache integration from outside the cluster.

**Prerequisites:** Phase 4 complete; ingress address known.

**Tasks:**

| ID | Endpoint | Method | Expected Result |
|---|---|---|---|
| S1 | /readyz | GET | HTTP 200 |
| S2 | /livez | GET | HTTP 200 |
| S3 | / (first request) | GET | HTTP 200; GitHub repo payload; Redis key set |
| S4 | / (second request) | GET | HTTP 200; response time faster (cache hit) |
| S5 | Pod logs post-smoke | inspect | Zero ERROR-level pino log entries |

**Rollback Trigger:** Any endpoint returns non-200, or Redis cache miss is never resolved, or ERROR logs appear — stop and diagnose before proceeding.

---

### Phase 6 — Post-Deployment Hardening (Effort: 1 day)

**Objective:** Activate HPA, confirm observability, and produce runbook.

**Tasks:**

| ID | Task | Effort | Go/No-Go Criteria |
|---|---|---|---|
| P6-1 | Verify HPA active: `kubectl get hpa -n atlas-prod` | 0.25h | TARGETS column shows numeric values (not `<unknown>`) |
| P6-2 | Confirm pino structured logs ingested by cluster logging stack | 0.5h | JSON log lines visible in Cloud Logging / Loki / Datadog |
| P6-3 | Set alert rules: HTTP 5xx rate > 1%, pod restart > 1/day, Redis conn error in logs | 1h | Alert rules deployed; test-fired |
| P6-4 | Document runbook: restart procedure, Redis failover, ingress TLS renewal | 2h | Runbook committed under docs/runbook.md |

---

## Dependency Sequencing

```
Phase 1 (Env Prep + Redis + Secrets)
  └─► Phase 2 (Image Build)
        └─► Phase 3 (Manifest Config)
              └─► Phase 4 (Deploy to atlas-prod)
                    └─► Phase 5 (Smoke Tests)
                          └─► Phase 6 (Post-Deployment Hardening)
```

## Timeline Summary

| Phase | Description | Effort |
|---|---|---|
| 1 | Environment Preparation | 0.5 day |
| 2 | Image Build and Push | 0.5 day |
| 3 | Manifest Configuration | 0.5 day |
| 4 | Deployment | 1 day |
| 5 | Smoke Tests | 0.5 day |
| 6 | Post-Deployment Hardening | 1 day |
| **Total** | | **~4 days** |

## Success Criteria (End-to-End)
1. All three API endpoints (/, /readyz, /livez) return HTTP 200 from ingress address
2. Redis cache integration validated (cache hit on second request)
3. All pods in Running+Ready state with no restart events
4. HPA active with numeric TARGETS
5. Pino structured logs flowing to cluster logging stack
6. Alert rules active and test-fired
7. Runbook published

## Recommended Next Command
`/implement_migration`
