variable resource_group_name {
  description = "name of the resource group to deploy AKS cluster in"
}

variable cluster_name {
  description = "AKS cluster name"
}

variable knative_eventing_version {
  description = "Version of Knative eventing which will be installed"
}


variable eventing_broker_config {
  default = <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-br-defaults
  namespace: knative-eventing
data:
  default-br-config: |
    # This is the cluster-wide default broker channel.
    clusterDefault:
      brokerClass: MTChannelBasedBroker
      apiVersion: v1
      kind: ConfigMap
      name: imc-channel
      namespace: knative-eventing
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: imc-channel
  namespace: knative-eventing
data:
  channelTemplateSpec: |
    apiVersion: messaging.knative.dev/v1
    kind: InMemoryChannel
EOF
}