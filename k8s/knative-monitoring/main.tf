# Knative installation

resource "null_resource" "knative_monitoring" {
  # Changes to any instance of the cluster requires re-provisioning
  # triggers = {
  #   cluster_instance_ids = "${join(",", aws_instance.cluster.*.id)}"
  # }

  #
  # Init CLI
  #

  # install cli 
  provisioner "local-exec" {
    command = "az aks install-cli"
  }

  # get credentials for cli 
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${var.resource_group_name} --name ${var.cluster_name}"
  }

  # 
  # Install Knative
  #

  # Install the Custom Resource Definitions (aka CRDs):
    provisioner "local-exec" {
    command = "kubectl apply --filename https://github.com/knative/serving/releases/download/v${var.knative_monitoring_version}/monitoring-core.yaml"
  }                                    


  # Install Prometheus and Grafana for metrics:

    provisioner "local-exec" {
      command = "kubectl apply --filename https://github.com/knative/serving/releases/download/v${var.knative_monitoring_version}/monitoring-metrics-prometheus.yaml"
  }

    # Run the following command and follow the instructions below to enable request logs if they are wanted:

    provisioner "local-exec" {
      command = "kubectl apply -f - ${var.config_observability}"
  }

    #Run the following command to install an ELK stack:
 
      provisioner "local-exec" {
      command = "kubectl apply --filename https://github.com/knative/serving/releases/download/v${var.knative_monitoring_version}/monitoring-logs-elasticsearch.yaml"
  }

     #Run the following command to ensure that the Fluentd DaemonSet runs on all your nodes:
 
      provisioner "local-exec" {
      command = "kubectl label nodes --all beta.kubernetes.io/fluentd-ds-ready=\"true\""
  }
 

 
# https://knative.dev/docs/serving/installing-logging-metrics-traces/

}

