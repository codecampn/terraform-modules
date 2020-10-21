# Knative installation

resource "null_resource" "knative_eventing" {
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
    command = "kubectl apply --filename https://github.com/knative/eventing/releases/download/v${var.knative_eventing_version}/eventing-crds.yaml"
  }

  # Install the core components of Eventing (see below for optional extensions):

    provisioner "local-exec" {
      command = "kubectl apply --filename https://github.com/knative/eventing/releases/download/v${var.knative_eventing_version}/eventing-core.yaml"
  }
  #  Install Messaging System 
  #  list of event soruces https://knative.dev/docs/eventing/sources/

    # install istio cli
   provisioner "local-exec" {
      command =  "kubectl apply --filename https://github.com/knative/eventing/releases/download/v${var.knative_eventing_version}/in-memory-channel.yaml"
  }

        

    # Install a Broker (eventing) layer:
     provisioner "local-exec" {
      command = "kubectl apply --filename https://github.com/knative/eventing/releases/download/v${var.knative_eventing_version}/mt-channel-broker.yaml"
  }
 

    provisioner "local-exec" {
      command = "mkdir eventing ; cat << EOF > ./eventing/broker-config.yaml \n${var.eventing_broker_config}"
  }

    provisioner "local-exec" {
      command = "kubectl apply --filename ./eventing/broker-config.yaml"
  }

  # Configure DNS

    provisioner "local-exec" {
      command = "kubectl get pods --namespace knative-eventing"
  }


  #####################################################################
  # Delete Service @TODO: Implement
  #####################################################################
  # provisioner "local-exec" {
  #   command = "kubectl delete --filename gke/knative/service.yml"
  #   when = "destroy"
  # }



}