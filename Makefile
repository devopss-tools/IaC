# make goals for devopss dev and production and test prodction 's infrastructure project

#variable Declaration
BIN_FOLDER := $(shell pwd)/bin
OPERATION := $(word 1,$(subst _, ,$(MAKECMDGOALS)))
VAULT_GEN_PASS_FILE := env/vault_key_password.sh
PLAYBOOK_DIR := playbooks

# Flags definition
ifdef ENVIRONMENT
	ENVIRONMENT :=  $(ENVIRONMENT)
else
	ENVIRONMENT :=
endif

VAULT_VARS_FILE := env/$(ENVIRONMENT)/group_vars/vault_variables.yml
COM_EXTRA_VARS := --extra-vars="@$(VAULT_VARS_FILE)" --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
#version decalartion
ANSIBLE_VERSION := 2.9.9
#ANSIBLE_VERSION := 2.8.6 - till 15.05.2020

$(info OPERATION : $(OPERATION))

# Flags definition
ifdef LIMIT_HOST
	ANSIBLE_LIMIT_HOST :=  --limit=$(LIMIT_HOST)
else
	ANSIBLE_LIMIT_HOST :=
endif

ifdef SSH_KEYS_TAG
	ANSIBLE_SSH_KEYS_TAG := --tags=$(SSH_KEYS_TAG)
else
	ANSIBLE_SSH_KEYS_TAG := --tags=ssh_user_deploy
endif

ifdef DEBUG_MODE
ANSIBLE_DEBUG_MODE := $(DEBUG_MODE)
  ifeq ($(DEBUG_MODE),true)
    ANSIBLE_VERBOSE := -vvvv
  else
    ANSIBLE_VERBOSE :=
  endif
endif

# unconditionally targets
.PHONY: help
# Start help
help:
	@echo "___________________________________________________ "
	@echo "                                                    "
	@echo "              devopss Agregator IAAS HELP               "
	@echo "configure_help : help for devops tools installation"
	@echo "display_allenv_hosts_gourps : diplay all envvironments host groups		"
	@echo "display_env_hosts_groups : diplay only specified envvironment host groups"
	@echo "configure_help : help for devops tools installation						"
	@echo "basic_installation : deploy basic linux configuration. Note : please add for each host ansible_ssh_user, ansible_ssh_pass and ansible_become_pass variables"
	@echo "ssh_users_deploy : deploy users public keys"
	@echo "ca_certs_deploy : deploy CA root certificates, LIMIT_HOST='localhost'"
	@echo "kafka_deploy : deploy and config kafka cluster"
	@echo "zookeeper_deploy : deploy and config zookeeper cluster"
	@echo "download_deploy : Deploy downlaod server, using user deploy"
	@echo "download_config : Deploy configuration downlaod server, using user deploy"
	@echo "postgresql_deploy : Deploy and config all components of Postgresql with server restart, using user deploy. Install-Config--InitDB"
	@echo "postgresql_install : install postgresql1 server on postgresql internal, using user deploy"
	@echo "postgresql_initdb : initdb postgresql12 with server restart, using user deploy"
	@echo "postgresql_config : config postgresql12 with server restart, using user deploy. Note! export ANSIBLE_VAULT_PASSWORD_FILE=path_to_vault_pass"
	@echo "postgresql_backup : testprod env postgresql backup. Note! export ANSIBLE_VAULT_PASSWORD_FILE=path_to_vault_pass"
	@echo "scdfdb_install : install postgresql12 server on scdf internal, using user deploy"
	@echo "scdfdb_initdb : initdb scdf postgresql12 with server restart, using user deploy"
	@echo "scdfdb_config : config  scdf postgresql12 with server restart, using user deploy. Note! export ANSIBLE_VAULT_PASSWORD_FILE=path_to_vault_pass"
	@echo "redis_install : install redis server, using user deploy"
	@echo "redis_config : config redis server, using user deploy"
	@echo "java_install : install Oracle JDK, using user deploy"
	@echo "zookeeper_deploy : deploy zookeeper cluster, using user deploy"
	@echo "etcd_deploy : deploy etcd cluster, using user deploy"
	@echo "docker_deploy : deploy docker, using user deploy"
	@echo "filestorage_container_deploy : deploy devopss Platform filestorage docker container, using user deploy"
	@echo "kubemaster_deploy : deploy kubemaster components, using user deploy"
	@echo "kubeworker_deploy : deploy kubeworker components, using user deploy"
	@echo "k8s_access_config : configure k8s access, LIMIT_HOST='localhost'"
	@echo "kubernetes_config_namespaces : configure Kubernetes Namespaces, LIMIT_HOST='localhost'"
	@echo "k8s_ingress_deploy : deploy Ingress Controller, LIMIT_HOST='localhost'"
	@echo "k8s_nfs_provisioner_deploy : deploy Ingress Controller, LIMIT_HOST='localhost'"
	@echo "k8s_mailu_deploy : deploy Mailu Server Controller, LIMIT_HOST='mailu-group'"
	@echo "devopss_io_ingress : apply devopss.io Ingress Rules, LIMIT_HOST='localhost'"
	@echo "nexus_deploy : deploy nexus components, using user deploy"
	@echo "nexus_config : deploy nexus components, using user deploy"
	@echo "nfs_deploy : deploy nfs components, using user deploy"
	@echo "nfs_config : config nfs components, using user deploy"
	@echo "scdf_install : deploy package SCDF, using user deploy"
	@echo "scdf_config : deploy config SCDF, using user deploy"
	@echo "sccs_install : deploy package SCCS, using user deploy"
	@echo "sccs_config : deploy config SCCS, using user deploy"
	@echo "es_install : deploy package ES, using user deploy"
	@echo "es_config : deploy config ES, using user deploy"
	@echo "es_scripts : deploy ES scripts, using user deploy"
	@echo "rabbitmq_install : deploy rabbitmq, using user deploy"
	@echo "es_index_install : install elasticsearch 5.6.x"
	@echo "es_index_conf : deploy configuration for elasticsearch"
	@echo "gateway_deploy : deploy nginx server, using user deploy"
	@echo "gateway_config : config nginx server, apply changes "
	@echo "sftp_deploy : deploy sftp server, using user deploy "
	@echo "sftp_deploy : deploy sftp server, using user deploy "
	@echo "gitlab_runner_deploy : deploy gitlab runner's, using user deploy. Dependency: docker. "
	@echo "gitlab_runner_config : config gitlab runner's, using user deploy "
	@echo "groovy_install : deploy groovy "
	@echo "encrypt_files : encrypt .csr, .pem and kubeconfig files. Req: .vault_password and LIMIT_HOST='localhost'"
	@echo "decrypt_files : decrypt .csr, .pem and kubeconfig files into target dir. Req: .vault_password and LIMIT_HOST='localhost'"
	@echo "______________________________________________________________________________________________________ "
	@echo "           Monitoring Deploy                        										"
	@echo "k8s_monitoring_tools : kibana and heartbeat deploy on k8s  "
	@echo "monitoring_heartbeat_rules : heartbeat config on k8s  				"
	@echo "filebeat_deploy : filebeat deploy and config for hosts logs monitoring  	   			"
	@echo "filebeat_k8s_deploy : filebeat deploy and config for k8s containers logs monitoring 	"
	@echo "______________________________________________________________________________________________________ "
	@echo "                                                    "
	@echo "             ANSIBLE DEBUG MODE                     "
	@echo "DEBUG_MODE values true/false, default false         "
	@echo "______________________________________________________________________________________________________"
	@echo "                                                    "
	@echo "             ANSIBLE LIMIT_HOST, ex:                "
	@echo "LIMIT_HOST='kafka-group' LIMIT_HOST='ansible-test-4' "
	@echo "______________________________________________________________________________________________________"
	@echo "                                                    "
	@echo "             ANSIBLE Decrypt Vault Variables        "
	@echo "export VAULT_PASSWORD='*********'			       "
	@echo "             ANSIBLE Vault Variables File:          "
	@echo "ansible/env/{{env}}/group_vars/vault_variables.yml  "
	@echo "                                                    "
	@echo "             ENVIRONMENT, ex:                	   "
	@echo "ENVIRONMENT=dev -> or datacenter or testprod         "
	@echo "______________________________________________________________________________________________________"
# END help

validate: display_env_hosts_groups
	@ansible --version >/dev/null 2>&1 || { echo "Ansible is not installed! Aborting. Invoke make configure. It will be installed in a virtual environment. To activate it, use source python_env/bin/activate" >&2; exit 100; }
	@ansible --version | grep  $(ANSIBLE_VERSION) || ( echo "Error Ansible Version, check make configure and Makefile <ANSIBLE_VERSION> variable ($(ANSIBLE_VERSION))"; exit 1 )
	@echo 'ANSIBLE_LIMIT_HOST: $(ANSIBLE_LIMIT_HOST)'
	@[ "${ANSIBLE_LIMIT_HOST}" ] || ( echo "make command parameter LIMIT_HOST is not set, ex: make help"; exit 1 )
	@[ "${ENVIRONMENT}" ] || ( echo "make command parameter ENVIRONMENT is not set (testprod, dev or datacenter)"; exit 1 )
	@echo " Check file ansible/$(VAULT_GEN_PASS_FILE) ..."
	@test -f ansible/$(VAULT_GEN_PASS_FILE) && echo ' File ansible/$(VAULT_GEN_PASS_FILE) exists; exit 1'
	@echo " Check env variable VAULT_PASSWORD ... !!!"
	@[ "${VAULT_PASSWORD}" ] || ( echo " Var VAULT_PASSWORD is not set"; exit 1 )

display_env_hosts_groups: validate
	@cd ansible ; ansible -i env/$(ENVIRONMENT)/hosts localhost -m debug -a 'var=groups.keys()' > /tmp/inventory; echo " "
	@echo " === All ENVIRONMENT < $(ENVIRONMENT) > groups  ===  "; cat /tmp/inventory | grep "groups.keys"; echo " "


# basic linux config
basic_installation: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/main_linux_conf.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)" --skip-tags "ssh_users_keys"
# basic linux config

# ssh users keys deploy
ssh_users_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)"  $(PLAYBOOK_DIR)/linux_deploy_users_ssh.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# ssh users keys deploy

# Generate CA certificates
ca_certs_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts $(PLAYBOOK_DIR)/ca_generate_cert.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# Generate CA certificates

# deploy Kafka Cluster
kafka_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" --tags "kafka_deploy" $(PLAYBOOK_DIR)/deploy_config_kafka.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" --tags "kafka_config" $(PLAYBOOK_DIR)/deploy_config_kafka.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# deploy Kafka Cluster

# deploy download server
download_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "download_deploy" $(PLAYBOOK_DIR)/main_download.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# deploy download server

# deploy config download server
download_config: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "download_config" $(PLAYBOOK_DIR)/main_download.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# deploy config download server

# deploy postgresql12 server
postgresql_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST)  --extra-vars="postgresql_handlers_action=restart" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/main_postgresql.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# deploy postgresql server

# install postgresql12
postgresql_install: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "pg12_install"  --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/main_postgresql.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# install postgresql12

# initdb postgresql12
postgresql_initdb: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "pg12_initdb" --extra-vars="postgresql_handlers_action=restart" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/main_postgresql.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# initdb postgresql12

# config postgresql12
postgresql_config: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "pg12_config" --extra-vars="postgresql_handlers_action=restart" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/main_postgresql.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# config postgresql12

# config postgresql backup
postgresql_backup: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "pg_install" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/testprod/backup_restore_postgresql.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "pg_backup"  $(PLAYBOOK_DIR)/testprod/backup_restore_postgresql.yml
# config postgresql backup

# install scdfdb
scdfdb_install: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "pg12_install" main_scdf.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# install scdfdb

# install redis-server
redis_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "redis_deploy"  --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/main_redis.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# install redis-server

# install redis-scdf
redis_install: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "redis_install"  --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/main_redis.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# install redis-scdf

# config redis-scdf
redis_config: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "redis_config"   --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/main_redis.yml   $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# config redis-scdf

# config etcd
etcd_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "etcd_deploy" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_config_etcd.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "etcd_config" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_config_etcd.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# config etcd

# deploy docker
docker_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "docker_deploy" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_config_docker.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "docker_config" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_config_docker.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# deploy docker

# deploy filestorage container
filestorage_container_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_filestorage_container.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# deploy filestorage container

# deploy kubemaster
kubemaster_deploy: validate kubemaster_config
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "k8smaster_deploy" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_config_k8smaster.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
kubemaster_config: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "k8smaster_config" --skip-tags "k8smaster_goss_tests" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_config_k8smaster.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "k8smaster_goss_tests" --skip-tags "k8smaster_config" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_config_k8smaster.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# deploy kubemaster

# deploy kubeworker
kubeworker_deploy: validate kubeworker_config
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "k8sworker_deploy" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_config_k8sworker.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)";
kubeworker_config: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "k8sworker_config" --skip-tags "k8sworker_goss_tests" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_config_k8sworker.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)";
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "k8sworker_goss_tests" --skip-tags "k8sworker_config" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_config_k8sworker.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)";
# deploy kubeworker


# config_k8s access
k8s_access_config: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --skip-tags "manage_namespaces" $(PLAYBOOK_DIR)/deploy_config_k8s_access.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)";
# config_k8s access

# Configure k8s Namespaces
kubernetes_config_namespaces: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST)  --tags "manage_namespaces" $(PLAYBOOK_DIR)/deploy_config_k8s_access.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
	$(MAKE) encrypt_files
# Configure k8s Namencrypt_filesespaces

# Deploy k8s Ingress Controller
k8s_ingress_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "ingress-controller"  $(PLAYBOOK_DIR)/deploy_containers_to_kubernetes.yml $(ANSIBLE_VERBOSE)  --vault-password-file="$(VAULT_GEN_PASS_FILE)" --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# Deploy k8s Ingress Controller

# Apply devopss.io k8s Ingress Rules
devopss_io_ingress: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "devopss-io-ingress"  $(PLAYBOOK_DIR)/deploy_containers_to_kubernetes.yml $(ANSIBLE_VERBOSE)  --vault-password-file="$(VAULT_GEN_PASS_FILE)" --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# Apply devopss.io  k8s Ingress Rules

# Deploy NFS Client Provisioner
k8s_nfs_provisioner_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "nfs-client-provisioner"  $(PLAYBOOK_DIR)/deploy_containers_to_kubernetes.yml $(ANSIBLE_VERBOSE)  --vault-password-file="$(VAULT_GEN_PASS_FILE)" --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# Deploy NFS Client Provisioner

# Deploy Maily Server
k8s_mailu_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VAULT_VARS_FILE)" --tags "mailu-server"  $(PLAYBOOK_DIR)/deploy_containers_to_kubernetes.yml $(ANSIBLE_VERBOSE)  --vault-password-file="$(VAULT_GEN_PASS_FILE)" --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# Deploy Maily Server

# deploy nexus
nexus_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "nexus_deploy" $(PLAYBOOK_DIR)/main_nexus.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# deploy nexus

# config nexus
nexus_config: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "nexus_config" $(PLAYBOOK_DIR)/main_nexus.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# config nexus
# deploy NFS
nfs_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "nfs_deploy" $(PLAYBOOK_DIR)/main_nfs.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# deploy nfs
nfs_config: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "nfs_config" $(PLAYBOOK_DIR)/main_nfs.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# deploy nfs

# install ES
es_install: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)"  --tags "es_install" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)"  $(PLAYBOOK_DIR)/main_es.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# install ES

# config ES
es_config: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)"  --tags "es_config" $(PLAYBOOK_DIR)/main_es.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# config ES

# deploy ES scripts
es_scripts: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)"  --tags "es_scripts" $(PLAYBOOK_DIR)/main_es.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# deploy ES scripts

## install ES index
#es_index_install: validate
#	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "es_install" $(PLAYBOOK_DIR)/main_es_index.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
## install ES
#
## configure ES index
#es_index_conf: validate
#	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "es_config" $(PLAYBOOK_DIR)/main_es_index.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
## install ES

# apply k8s monitoring kibana and heartbeat deployments
k8s_monitoring_tools: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "monitoring-kibana" $(PLAYBOOK_DIR)/deploy_containers_to_kubernetes.yml $(ANSIBLE_VERBOSE)  --vault-password-file="$(VAULT_GEN_PASS_FILE)" --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "monitoring-heartbeat"  $(PLAYBOOK_DIR)/deploy_containers_to_kubernetes.yml $(ANSIBLE_VERBOSE)  --vault-password-file="$(VAULT_GEN_PASS_FILE)" --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# apply k8s monitoring deployments

# apply k8s monitoring kibana and heartbeat deployments
k8s_kibana_general: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "kibana-general" $(PLAYBOOK_DIR)/deploy_containers_to_kubernetes.yml $(ANSIBLE_VERBOSE)  --vault-password-file="$(VAULT_GEN_PASS_FILE)" --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# apply k8s monitoring deployments

# apply heartbeat rules
monitoring_heartbeat_rules: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts -i env/$(ENVIRONMENT)/hosts-monitoring  $(ANSIBLE_LIMIT_HOST) --tags "monitoring-heartbeat-rules" $(PLAYBOOK_DIR)/deploy_monitoring_heartbeat_config_rules.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# apply heartbeat rules

# apply fileabeat deploy and/or config for kubernetes containers monitoring
filebeat_k8s_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "monitoring-filebeat"  $(PLAYBOOK_DIR)/deploy_containers_to_kubernetes.yml $(ANSIBLE_VERBOSE)  --vault-password-file="$(VAULT_GEN_PASS_FILE)" --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# apply fileabeat deploy and/or config for kubernetes containers monitoring

# apply fileabeat deploy and/or config on hosts
filebeat_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "filebeat_install" $(PLAYBOOK_DIR)/deploy_monitoring_filebeat.yml $(ANSIBLE_VERBOSE)  --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(COM_EXTRA_VARS)
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "filebeat_config" $(PLAYBOOK_DIR)/deploy_monitoring_filebeat.yml $(ANSIBLE_VERBOSE)  --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(COM_EXTRA_VARS)
filebeat_config: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "filebeat_config" $(PLAYBOOK_DIR)/deploy_monitoring_filebeat.yml $(ANSIBLE_VERBOSE)  --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(COM_EXTRA_VARS)
# apply fileabeat deploy and/or config on hosts

# deploy mongodb
deploy_mongo: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "mongodb_deploy" $(PLAYBOOK_DIR)/deploy_config_mongodb.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# deploy mongodb

# deploy mongodb
config_mongo: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "mongodb_config" $(PLAYBOOK_DIR)/deploy_config_mongodb.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# deploy mongodb

# install rabbitmq
rabbitmq_install: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" --tags "rabbitmq_deploy" $(PLAYBOOK_DIR)/main_rabbitmq.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# install rabbitmq

## deploy docker
#download_deploy: validate
#	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "download_deploy" $(PLAYBOOK_DIR)/main_download.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
## deploy docker

# gateway deploy
gateway_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "gateway_deploy" $(PLAYBOOK_DIR)/main_gateway.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# gateway deploy

# gateway config
gateway_config: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "gateway_config" $(PLAYBOOK_DIR)/main_gateway.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# gateway config


# haproxy gateway deploy
haproxy_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "haproxy_deploy" $(PLAYBOOK_DIR)/main_haproxy_gateway.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# haproxy gateway deploy

# haproxy gateway config
haproxy_config: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "haproxy_config" $(PLAYBOOK_DIR)/main_haproxy_gateway.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# haproxy gateway deploy

# encryption / decryption
encrypt_files: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "encryption" $(PLAYBOOK_DIR)/encryption_decryption_files.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
decrypt_files: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "decryption" $(PLAYBOOK_DIR)/encryption_decryption_files.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)"
# encryption / decryption

# mysql deploy
mysql_deploy: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "mysql_install"  $(PLAYBOOK_DIR)/main_mysql.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)"
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "mysql_config"  $(PLAYBOOK_DIR)/main_mysql.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)"
# mysql deploy

# gitlab_runner config/deploy
gitlab_runner_deploy: validate docker_deploy
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "gitlab_runner_deploy" $(PLAYBOOK_DIR)/deploy_gitlab_runner.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)"
gitlab_runner_config: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --tags "gitlab_runner_config" $(PLAYBOOK_DIR)/deploy_gitlab_runner.yml $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)"
# gitlab_runner config/deploy

# aria2 install
aria2_install: validate
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST)  --tags "download_deploy" $(PLAYBOOK_DIR)/main_download.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT) --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)""
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST)  --tags "download_config" $(PLAYBOOK_DIR)/main_download.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT) --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)""
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST)  --tags "download_deploy" $(PLAYBOOK_DIR)/deploy_aria2.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)"
	cd ansible ; ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST)  --tags "download_config" $(PLAYBOOK_DIR)/deploy_aria2.yml  $(ANSIBLE_VERBOSE)  --extra-vars="ansible_root_path=${PWD}/ansible env_name=$(ENVIRONMENT)" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)"
# aria2 install


ifeq ($(OPERATION),configure)
-include ./configure/Makefile
endif