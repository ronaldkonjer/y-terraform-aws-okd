provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

# To force resource recreation, there are duplicate resources for each environment

# Create the private key for the registration
resource "tls_private_key" "reg_private_key_staging" {
  count     = "${var.acme_server_env == "staging" ? 1 : 0}"
  algorithm = "RSA"
  rsa_bits  = 4096

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_private_key" "reg_private_key_prod" {
  count     = "${var.acme_server_env == "prod" ? 1 : 0}"
  algorithm = "RSA"
  rsa_bits  = 4096

  lifecycle {
    create_before_destroy = true
  }
}

# Set up registration server
provider "acme" {
  alias      = "staging"
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

provider "acme" {
  alias      = "prod"
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

# Set up a registration using a private key from tls_private_key
resource "acme_registration" "reg_staging" {
  count           = "${var.acme_server_env == "staging" ? 1 : 0}"
  provider        = "acme.staging"
  account_key_pem = "${tls_private_key.reg_private_key_staging.private_key_pem}"
  email_address   = "${var.platform_domain_administrator_email}"
}

resource "acme_registration" "reg_prod" {
  provider        = "acme.prod"
  count           = "${var.acme_server_env == "prod" ? 1 : 0}"
  account_key_pem = "${tls_private_key.reg_private_key_prod.private_key_pem}"
  email_address   = "${var.platform_domain_administrator_email}"
}

# Create the private key for the certificate
resource "tls_private_key" "cert_private_key_staging" {
  count     = "${var.acme_server_env == "staging" ? 1 : 0}"
  algorithm = "RSA"
  rsa_bits  = 4096

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_private_key" "cert_private_key_prod" {
  count     = "${var.acme_server_env == "prod" ? 1 : 0}"
  algorithm = "RSA"
  rsa_bits  = 4096

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_cert_request" "req_staging" {
  count           = "${var.acme_server_env == "staging" ? 1 : 0}"
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.cert_private_key_staging.private_key_pem}"
  dns_names       = ["${var.platform_domain}"]

  subject {
    common_name = "*.${var.platform_domain}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_cert_request" "req_prod" {
  count           = "${var.acme_server_env == "prod" ? 1 : 0}"
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.cert_private_key_prod.private_key_pem}"
  dns_names       = ["${var.platform_domain}"]

  subject {
    common_name = "*.${var.platform_domain}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create a certificate.
resource "acme_certificate" "certificate_staging" {
  count                   = "${var.acme_server_env == "staging" ? 1 : 0}"
  provider                = "acme.staging"
  account_key_pem         = "${acme_registration.reg_staging.account_key_pem}"
  certificate_request_pem = "${tls_cert_request.req_staging.cert_request_pem}"
  min_days_remaining      = 7

  dns_challenge {
    provider = "route53"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "acme_certificate" "certificate_prod" {
  count                   = "${var.acme_server_env == "prod" ? 1 : 0}"
  provider                = "acme.prod"
  account_key_pem         = "${acme_registration.reg_prod.account_key_pem}"
  certificate_request_pem = "${tls_cert_request.req_prod.cert_request_pem}"
  min_days_remaining      = 7

  dns_challenge {
    provider = "route53"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_server_certificate" "iam_server_certificate" {
  name_prefix = "${var.platform_domain}-"

  certificate_body  = "${coalesce(join(",",acme_certificate.certificate_staging.*.certificate_pem),join(",",acme_certificate.certificate_prod.*.certificate_pem))}"
  certificate_chain = "${coalesce(join(",",acme_certificate.certificate_staging.*.issuer_pem),join(",",acme_certificate.certificate_prod.*.issuer_pem))}"
  private_key       = "${coalesce(join(",",tls_private_key.cert_private_key_staging.*.private_key_pem),join(",",tls_private_key.cert_private_key_prod.*.private_key_pem))}"
  path              = "/certs/"

  lifecycle {
    create_before_destroy = true
  }

  provisioner "local-exec" {
    command = "sleep 10"
  }
}
