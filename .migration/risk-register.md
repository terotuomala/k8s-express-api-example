# Risk Register

## Context
- run_id: run-20260620-032937
- repo: terotuomala/k8s-express-api-example
- source: https://github.com/terotuomala/k8s-express-api-example
- generated_at: 2026-06-20T16:26:00Z
- total_risks: 7 (2 HIGH, 3 MEDIUM, 2 LOW)
- overall_risk_level: MEDIUM (mitigated to LOW-MEDIUM with pre-deployment actions)

## Risk Register

### HIGH RISKS

| Risk ID | Title | Probability | Impact | Severity | Owner | Mitigation | Detection | Remediation |
|---|---|---|---|---|---|---|---|---|
| R-H1 | Redis unavailability changes execution path silently | 70% | API returns stale or empty data; cache miss fallback behaviour not documented | HIGH | Platform/Dev | Provision Redis before any deploy; add Redis readiness probe to Kubernetes deployment; document fallback behaviour in runbook | `ioredis` connection error in pino logs; smoke test S3 fails to populate cache key | Rollback pod to previous revision; restore Redis connectivity; verify cache hit on retry |
| R-H2 | GITHUB_API_URL and REDIS_DEFAULT_EXPIRATION have no observed defaults | 85% | Pod starts but API returns 500 on first request if Secret is missing or misconfigured | HIGH | Platform | Create and validate Secret before Phase 4; confirm env vars are injected via `kubectl exec -- env | grep GITHUB` | Pod logs show `undefined` or `ENOENT` on startup; /readyz returns 200 but / returns 500 | Patch Secret; `kubectl rollout restart deployment -n atlas-prod` |

### MEDIUM RISKS

| Risk ID | Title | Probability | Impact | Severity | Owner | Mitigation | Detection | Remediation |
|---|---|---|---|---|---|---|---|---|
| R-M1 | GitHub API rate limit degrades endpoint SLA | 40% | GET / returns 429 or slow response; cache miss amplifies risk | MEDIUM | Dev | Set REDIS_DEFAULT_EXPIRATION high enough to avoid repeated upstream calls; implement exponential backoff in src/api/index.js | 429 response code in pino logs; elevated P95 latency on / endpoint | Increase REDIS_DEFAULT_EXPIRATION; implement backoff if not already present |
| R-M2 | Network policy egress misconfiguration blocks GitHub API | 35% | GET / returns 500 or times out; appears as application bug, not infra | MEDIUM | Platform | Validate egress policy in Phase 1 using curl from test pod; confirm netpol-egress selector permits api.github.com:443 | All requests to / return 500 or timeout; /readyz and /livez remain 200 | Update netpol-egress; reapply; confirm with test pod curl |
| R-M3 | HPA TARGETS column shows unknown due to missing metrics-server | 30% | HPA unable to auto-scale; risk of pod saturation under load | MEDIUM | Platform | Confirm metrics-server is installed in cluster: `kubectl get deploy -n kube-system metrics-server`; install if absent | `kubectl get hpa -n atlas-prod` shows TARGETS=`<unknown>` | Install metrics-server; wait ~2 min; re-check HPA |

### LOW RISKS

| Risk ID | Title | Probability | Impact | Severity | Owner | Mitigation | Detection | Remediation |
|---|---|---|---|---|---|---|---|---|
| R-L1 | PDB minAvailable conflicts with HPA minReplicas causing disruption stall | 20% | Node drain blocked; cluster maintenance window stalls | LOW | Platform | Confirm PDB minAvailable < HPA minReplicas before Phase 3 apply; review k8s/base/pdb.yaml | `kubectl drain` blocks with PDB violation error | Update pdb.yaml to allow at least 1 disruption when minReplicas > 1 |
| R-L2 | npm package lock drift between build and runtime image | 15% | Module resolution failure at container start | LOW | Build | Use `npm ci` (not `npm install`) in Dockerfile to enforce lock file | Pod CrashLoopBackOff on start; `MODULE_NOT_FOUND` in logs | Rebuild image with corrected Dockerfile; re-push and re-deploy |

## Risk Mitigation Timeline

### Pre-Deployment (Phase 1 Gate — Must Complete Before Proceeding)

| Risk ID | Pre-Gate Action | Verified By |
|---|---|---|
| R-H1 | Redis provisioned and reachable from cluster | redis-cli ping returns PONG |
| R-H2 | Secret created with all required env vars; test pod confirms injection | `kubectl exec -- env` shows GITHUB_API_URL and REDIS_DEFAULT_EXPIRATION |
| R-M2 | Egress policy validated: curl from test pod to GITHUB_API_URL succeeds | HTTP 200 or 304 from curl |

### During Deployment (Continuous — Phases 4–5)

| Risk ID | Monitor | Escalation Trigger | Action |
|---|---|---|---|
| R-H1 | Pod logs for ioredis connection errors | Any REDIS connection error in logs | Stop Phase 5; fix Redis; restart pods |
| R-M1 | HTTP response codes on / endpoint | 429 from GitHub API | Increase REDIS_DEFAULT_EXPIRATION; retry smoke test |
| R-M3 | `kubectl get hpa -n atlas-prod` | TARGETS shows `<unknown>` | Install metrics-server; re-check |

## Risk Dependencies

```
R-H2 (missing env vars) → blocks Phase 4 (deploy)
R-H1 (Redis unavailable) → blocks Phase 5 (smoke S3/S4)
R-M2 (egress misconfiguration) → blocks smoke S3 (GitHub API call)
R-M1 (GitHub rate limit) → intermittent smoke S3 failure
R-M3 (metrics-server missing) → blocks Phase 6 HPA validation
R-L1 (PDB conflict) → detected in Phase 3 dry-run
R-L2 (npm drift) → detected in Phase 2 build
```

## Risk Compliance
- Evidence-grounded: All risks derived from assessment-summary.md, env-mapping.json, and dependency-graph.json
- Deterministic: Probability/impact scored from observed discovery signals
- Measurable: Each risk has explicit detection method and remediation command
- Pre-mitigation gate: R-H1, R-H2, R-M2 must be mitigated before Phase 4
