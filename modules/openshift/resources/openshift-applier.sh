#!/bin/bash

export LANG=C
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_FORKS=5
export ANSIBLE_PIPELINING=True

export AWS_REGION="${platform_aws_region}"

ocinventory -cluster "${platform_name}" -inventory $HOME/template-inventory.yaml > $HOME/inventory.yaml

# ansible-playbook -i $HOME/inventory.yaml openshift-applier/openshift-policies/config.yml -vvv || { echo "Error on applier" ; exit 1 ; }
ansible-playbook -i $HOME/inventory.yaml openshift-applier/openshift-hybris/playbooks/setup_y_env.yml -vvv || { echo "Error on applier setup hybris environment" ; exit 1 ; }
