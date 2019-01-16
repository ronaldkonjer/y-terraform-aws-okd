data "template_file" "template_inventory" {
  template = "${file("${path.module}/resources/template-inventory.yaml")}"

  vars {
    platform_name                  = "${var.platform_name}"
    ansible_user                   = "${var.bastion_ssh_user}"
    rhn_username                   = "${var.rhn_username}"
    rhn_password                   = "${var.rhn_password}"
    rh_subscription_pool_id        = "${var.rh_subscription_pool_id}"
    platform_domain                = "${var.platform_domain}"
    master_domain                  = "${var.master_domain}"
    openshift_deployment_type      = "${var.use_community ? "origin" : "openshift-enterprise"}"
    openshift_major_version        = "${var.openshift_major_version}"
    openshift_repos_enable_testing = "${var.use_community ? "true" : "false"}"
    named_certificate              = "${(var.public_certificate_pem == "") ? false : true}"
    aws_region                     = "${data.aws_region.current.name}"
  }
}

resource "null_resource" "template_inventory" {
  provisioner "file" {
    content     = "${data.template_file.template_inventory.rendered}"
    destination = "~/template-inventory.yaml"
  }

  connection {
    type        = "ssh"
    user        = "${var.bastion_ssh_user}"
    private_key = "${var.platform_private_key}"
    host        = "${var.bastion_endpoint}"
  }

  triggers {
    template_inventory = "${data.template_file.template_inventory.rendered}"
  }
}
