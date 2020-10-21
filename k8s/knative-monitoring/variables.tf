variable resource_group_name {
  description = "name of the resource group to deploy AKS cluster in"
}

variable cluster_name {
  description = "AKS cluster name"
}

variable knative_monitoring_version {
  description = "Version of Knative monitoring which will be installed"
}

# variable config_observability {
#   default = <<EOF
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   name: config-observability
#   labels:
#     serving.knative.dev/release: devel

# data:
#   logging.enable-var-log-collection: true
#   logging.revision-url-template: |
#     http://localhost:8001/api/v1/namespaces/knative-monitoring/services/kibana-logging/proxy/app/kibana#/discover?_a=(query:(match:(kubernetes.labels.serving-knative-dev%2FrevisionUID:(query:'${REVISION_UID}',type:phrase))))
#   logging.request-log-template: '{"httpRequest": {"requestMethod": "{{.Request.Method}}", "requestUrl": "{{js .Request.RequestURI}}", "requestSize": "{{.Request.ContentLength}}", "status": {{.Response.Code}}, "responseSize": "{{.Response.Size}}", "userAgent": "{{js .Request.UserAgent}}", "remoteIp": "{{js .Request.RemoteAddr}}", "serverIp": "{{.Revision.PodIP}}", "referer": "{{js .Request.Referer}}", "latency": "{{.Response.Latency}}s", "protocol": "{{.Request.Proto}}"}, "traceId": "{{index .Request.Header "X-B3-Traceid"}}"}'
#   metrics.backend-destination: prometheus
#   metrics.request-metrics-backend-destination: prometheus
#   metrics.allow-stackdriver-custom-metrics: "false"
#   profiling.enable: "true"

# EOF
# }


