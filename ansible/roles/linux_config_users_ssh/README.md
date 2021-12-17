linux_config_users_ssh
=========
ansible-playbook linux_deploy_users_ssh.yml -i env/{{ env_name }}/hosts

Requirements
------------
Must to do the following steps:
1. Add all users into file: ansible/env/{{ env_name }}/group_vars/ssh-users-groups.yml
users:
  {{ key_name }}:
    name: {{ user_name }}
    osGroup: {{ OS Group Name }}
    hosts: " List of hosts, comma separated where key will be deployed for active users "
    status: " active or non-active, every not 'active' string will be set like 'non-active' "
    
2. Store all user keys into directory: ansible/pub_ssh_keys

    
Role Variables
--------------
linux_config_deploy_user_name: default deploy user with root permissions  
linux_config_deploy_group_name: default deploy group with root permissions  
repo_pub_ssh_keys: repository for users public keys

Dependencies
------------

Notes
-----
1. ansible-playbook main_linux_conf.yml deploys only "deploy" user/ssh_keys
2. OS username will be set from users.{{ key_name }}.name
3. ssh user keys will be deployed into: /home/{{ user_name }}/.ssh/authorized_keys  
4. users.{{ key_name }}.name and user_key_file_name have to be the same, ex: 
Key file name: danudumbraveanu.pub
Structure of users ssh keys file:
users:
  danudumbraveanu:
    name: danudumbraveanu
  ...
 
Example Playbook
----------------
