#backend.tf => comment out
terraform {
  backend "s3" {}
}

#If not done yet, create a workspace
terraform workspace new stage

#Select workspace
make workspace ENV=stage

#Initialize the project
make init
make remote-state ENV=stage

#backend.tf => uncomment
terraform {
  backend "s3" {}
}

#Initialize the remote state in S3
make init-remote-stage
make refresh ENV=stage

make install ENV=stage

terraform state pull > terraform.tfstate