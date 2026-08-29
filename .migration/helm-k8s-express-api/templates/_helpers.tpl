{{/*
Expand the name of the chart.
*/}}
{{- define "k8s-express-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "k8s-express-api.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "k8s-express-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "k8s-express-api.labels" -}}
helm.sh/chart: {{ include "k8s-express-api.chart" . }}
{{ include "k8s-express-api.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "k8s-express-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "k8s-express-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ include "k8s-express-api.fullname" . }}
{{- end }}
