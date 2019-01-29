.PHONEY: all network infra domain remote-state rds_cluster elasticache_cluster install destroy

key:
	@terraform output platform_private_key > /tmp/.openshift-`terraform output platform_name`.key
	@chmod 600 /tmp/.openshift-`terraform output platform_name`.key

sshspec:
	@terraform output bastion_ssh_spec

ssh-bastion: key
	@ssh -o IdentitiesOnly=yes `make sshspec` -i /tmp/.openshift-`terraform output platform_name`.key

ssh-bastion-openshift:
	@echo "Login to Bastion and run openshift-install.sh"
	@ssh -o IdentitiesOnly=yes `make sshspec` -i /tmp/.openshift-`terraform output platform_name`.key "~/deploy-cluster.sh"

console:
	@open `terraform output master_public_url`

init:
	@terraform init

workspace:
	@terraform workspace select $(ENV)

remote-state: 
	@echo "Builds remote-state in S3 for Terraform in $(ENV)"
	@terraform apply -target module.remote-state -var-file workspace-variables/$(ENV).tfvars

#Can't use variables on backend.tf. So we define a parameterized command 
init-remote-stage:
	@echo "initialize terrafrom with remote state in S3 for stage environment"
	#@terraform init -var aws_profile=default -var-file workspace-variables/stage.tfvars 
	@terraform init -backend-config="encrypt=true" -backend-config="bucket=terraform-state-yokd-stage" -backend-config="dynamodb_table=terraform-state-lock-yokd-stage" -backend-config="region=eu-west-1" -backend-config="key=terraform.tfstate.d/stage/terraform.tfstate"

init-remote-prod:
	@echo "initialize terrafrom with remote state in S3"
	#@terraform init -var aws_profile=default -var-file workspace-variables/stage.tfvars 
	@terraform init -backend-config="encrypt=true" -backend-config="bucket=terraform-state-yokd-prod" -backend-config="dynamodb_table=terraform-state-lock-yokd-prod" -backend-config="region=eu-west-1" -backend-config="key=terraform.tfstate.d/prod/terraform.tfstate"

refresh:
	@echo "refresh the state for remote-state in S3 $(ENV)"
	#@terraform init -var aws_profile=default -var-file workspace-variables/stage.tfvars 
	@terraform refresh -var-file workspace-variables/$(ENV).tfvars

pull-state:
	@echo "if for some reason you need the state at your local machine"
	@terraform state pull > terraform.tfstate -var-file workspace-variables/$(ENV).tfvars

plan:
	@echo "Plan Openshift in $(ENV)"
	@terraform plan -var-file workspace-variables/$(ENV).tfvars

all: domain rds_cluster elasticache_cluster openshift

install: domain openshift

network: 
	@echo "Builds network for OpenShift in $(ENV)"
	@terraform apply -target module.network -var-file workspace-variables/$(ENV).tfvars

infra: network
	@echo "Builds infrastructure for OpenShift in $(ENV)"
	@terraform apply -target module.infrastructure -var-file workspace-variables/$(ENV).tfvars

domain: infra
	@echo "Builds domain zone for OpenShift in $(ENV)"
	@terraform apply -target module.domain -var-file workspace-variables/$(ENV).tfvars

rds_cluster:
	@echo "Builds rds_cluster zone for OpenShift in $(ENV)"
	@terraform apply -target module.rds_cluster -var-file workspace-variables/$(ENV).tfvars

elasticache_cluster:
	@echo "Builds elasticache_cluster zone for OpenShift in $(ENV)"
	@terraform apply -target module.elasticache_cluster -var-file workspace-variables/$(ENV).tfvars

openshift:
	@echo "Install OpenShift in $(ENV)"
	@terraform apply -target module.openshift -var-file workspace-variables/$(ENV).tfvars

destroy: destory-network destory-infra destroy-domain destroy-rds_cluster destroy-elasticache_cluster

destory-network: 
	@echo "Destroy platform network resources ..."
	@terraform apply -target module.network -var-file workspace-variables/$(ENV).tfvars

destory-infra: network
	@echo "Destroy platform network resources ..."
	@terraform apply -target module.infrastructure -var-file workspace-variables/$(ENV).tfvars

destory-domain: infra
	@echo "Destroy platform network resources ..."
	@terraform apply -target module.domain -var-file workspace-variables/$(ENV).tfvars

destory-rds_cluster:
	@echo "Destroy platform network resources ..."
	@terraform apply -target module.rds_cluster -var-file workspace-variables/$(ENV).tfvars

destory-elasticache_cluster:
	@echo "Destroy platform network resources ..."
	@terraform apply -target module.elasticache_cluster -var-file workspace-variables/$(ENV).tfvars


