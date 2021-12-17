kubernetes_access_config
=========
ansible-playbook -i env/{{ env }}/hosts  --tags "manage_namespaces" deploy_config_k8s_access.yml


Requirements
------------
Must to do the following steps:
1. Add all users into file: ansible/env/{{ env_name }}/group_vars/ssh-users-groups.yml
namespaces:
  {{ key_name }}:
    name: {{ namespace_name }}
    role: {{ k8s cluster role }}
    status: " active or non-active, every not 'active' string will be set like 'non-active' "
    
    
Role Variables
--------------
k8s_access_roles_dir: directory to store k8s namespace.users certificates and kube config file
kubeadmin_dir: directory to store k8s namespace.admin certificates and kube config file

Dependencies
------------

Notes
-----
1. One namespace for one project (deployment environment) 
2. namespaces.{{ key_name }}.name will be , ex: 
3. Role have to be admin/edit/view (k8s exiting default roles)
4. Status check - not implemented 
  
Example Playbook
----------------