# Knative installation

resource "null_resource" "knative_serving" {
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
    command = "kubectl apply --filename https://github.com/knative/serving/releases/download/v${var.knative_serving_version}/serving-crds.yaml"
  }

  # Install the core components of Serving (see below for optional extensions):

    provisioner "local-exec" {
      command = "kubectl apply --filename https://github.com/knative/serving/releases/download/v${var.knative_serving_version}/serving-core.yaml"
  }
  #  Installing Istio for Knative
  #  Install the Knative Istio controller:

    # install istio cli
   provisioner "local-exec" {
      # command =  "curl -sL https://istio.io/downloadIstioctl | sh - ; export PATH=$PATH:$HOME/.istioctl/bin"
      # command =  "curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.6.8 TARGET_ARCH=x86_64 sh - ; export PATH=$PATH:$HOME/.istioctl/bin"
      command =  "curl -L https://istio.io/downloadIstioctl | ISTIO_VERSION=1.6.12 TARGET_ARCH=x86_64 sh - ; export PATH=$PATH:$HOME/.istioctl/bin"
  }

        
        
    # install istio minimal operator

    provisioner "local-exec" {
      command = "mkdir istio ; cat << EOF > ./istio/istio-minimal-operator.yaml \n${var.istio_operator}"
    }


     provisioner "local-exec" {
      command = "istioctl manifest apply -f ./istio/istio-minimal-operator.yaml"
  }
 

    provisioner "local-exec" {
      command = "kubectl apply --filename https://github.com/knative/net-istio/releases/download/v${var.knative_serving_version}/release.yaml"
  }

  # Fetch the External IP or CNAME: 
    provisioner "local-exec" {
      command = "kubectl --namespace istio-system get service istio-ingressgateway"
  }

  # test if it is working

    provisioner "local-exec" {
      command = "kubectl get pods --namespace knative-serving"
  }

    # Configure DNS

    provisioner "local-exec" {
      command = "kubectl patch configmap/config-domain  --namespace knative-serving --type merge  --patch '{\"data\":{\"${var.custom_domain_name}\":\"\"}}'"
  }

  #Knative supports automatically provisioning TLS certificates using Let’s Encrypt HTTP01 
  #challenges. The following commands will install the components needed to support that.
  #First, install the net-http01 controller:

  provisioner "local-exec" {
      command = "kubectl apply --filename https://github.com/knative/net-http01/releases/download/v0.18.0/release.yaml"
  }

#  Next, configure the certificate.class to use this certificate type.

  provisioner "local-exec" {
      command = "kubectl patch configmap/config-network --namespace knative-serving --type merge --patch '{\"data\":{\"certificate.class\":\"net-http01.certificate.networking.knative.dev\"}}'"
  }

# lastly enable auto-tls

  provisioner "local-exec" {
      command = "kubectl patch configmap/config-network --namespace knative-serving --type merge --patch '{\"data\":{\"autoTLS\":\"Enabled\"}}'"
  }






  #####################################################################
  # Delete Service @TODO: Implement
  #####################################################################
  # provisioner "local-exec" {
  #   command = "kubectl delete --filename gke/knative/service.yml"
  #   when = "destroy"
  # }



}


# curl -H "Host: helloworld.default.kn.buml.cc-n.dev" http://20.54.226.116