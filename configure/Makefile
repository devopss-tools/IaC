VIRTUAL_ENV := python_env

configure_help:
	@echo "*******************HELP for Configure ***************************"
	@echo "configure : configure devops environment"
	@echo "*****************************************************************"

# Start validate
validate:
	@virtualenv --version > /dev/null 2>&1 || { echo "virtualenv is not installed!" >&2; exit 100; }
# END validate

# Start clean
clean:
	@rm -fr $(BIN_FOLDER)
# END clean

# Start init
init: validate clean
	@mkdir $(BIN_FOLDER)
# END init

# Start to install the package
install_%:
	@bash -c "source "$(BIN_FOLDER)"/"$(VIRTUAL_ENV)"/bin/activate	&& \
		pip install "$(PKG)"=="$(VER)" kubernetes==11.0 kubernetes-validate==1.18 openshift==0.11.2 jmespath==0.10 selinux==0.2 && \
		which python	&& \
		pip freeze	&& \
		deactivate"

# Declaration of virtual environment
config_virtualenv:
	@bash configure/create_virtualenv.sh  $(BIN_FOLDER)/$(VIRTUAL_ENV)

# Install and configure config_cfssl
config_cfssl:
	@bash -c "curl -v -s -L -o $(BIN_FOLDER)/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64   && \
 	          curl -v -s -L -o $(BIN_FOLDER)/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64   && \
              chmod -v +x $(BIN_FOLDER)/{cfssl,cfssljson} "

# Install and configure rakkess (k8s audit)
config_rakkess:
	@bash -c "curl -Lo $(BIN_FOLDER)/rakkess.gz https://github.com/corneliusweig/rakkess/releases/download/v0.4.1/rakkess-linux-amd64.gz && \
 	          gunzip $(BIN_FOLDER)/rakkess.gz && chmod +x $(BIN_FOLDER)/rakkess && rm -fv gunzip $(BIN_FOLDER)/rakkess.gz"

#Declaration of ansible
config_ansible: PKG=ansible
config_ansible:	VER="$(ANSIBLE_VERSION)"
config_ansible:	install_ansible

configure: init config_virtualenv config_ansible config_cfssl config_rakkess
