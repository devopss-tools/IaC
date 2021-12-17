Encryption 
==========
```shell
make encrypt_files  LIMIT_HOST='localhost' ENVIRONMENT=dev
```
Decryption 
==========
```shell
make decrypt_files  LIMIT_HOST='localhost' ENVIRONMENT=dev
```
View encrypted file 
===================
```shell
cd ansible
#ansible-vault view certificates/datacenter/k8s_access_roles/kubeadmin/admin.kubeconfig
ansible-vault view {{ certificates_root_path }}/k8s_access_roles/kubeadmin/admin.kubeconfig
```
Manual Encryption 
==========
```shell
cd ansible
ansible-vault encrypt certificates/datacenter/k8s_access_roles/kubeadmin/admin.kubeconfig
ansible-vault encrypt {{ certificates_root_path }}/k8s_access_roles/kubeadmin/admin.kubeconfig
```
Requirements
------------
* add vault encryption password into .vault_password file to root directory


Role Variables
--------------



Dependencies
------------



Example Playbook
----------------
