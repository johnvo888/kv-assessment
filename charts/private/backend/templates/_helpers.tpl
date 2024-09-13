{{- define "image" -}}
{{- $registryName := .Values.global.image.registry -}}
{{- $repositoryName := .Values.global.image.repository -}}
{{- $tag := .Values.global.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global.imageRegistry }}
  {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
{{- else -}}
  {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{- define "backend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "backend.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end -}}
{{- end -}}

{{- define "backend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "backend.labels" -}}
helm.sh/chart: {{ include "backend.chart" . }}
{{ include "backend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}