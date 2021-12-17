nexus_deploy
============
ansible-playbook -i env/${environment}/hosts -vvvv  --tags "nexus_deploy" deploy_nexus.yml --limit nexus-group

Requirements
------------
1. Volume: mount disk required (min 4GB free space for Nexus) of {{ disk_device }} variable. See defaults/main.yml
2. Apply docker deploy role:
ansible-playbook -i env/${environment}/hosts -vvvv  --tags "docker_deploy" deploy_config_docker.yml --limit nexus-group
ansible-playbook -i env/${environment}/hosts -vvvv  --tags "docker_config" deploy_config_docker.yml --limit nexus-group

Role Variables
--------------
container_docker_image:     Nexus Registry OSS v3 docker image name
container_docker_tag:       Nexus Registry OSS v3 docker image tag
container_nexus_data_dir:   Nexus Registry OSS v3 data dir, inside docker container
volume_nexus_data_dir:      Nexus Registry OSS v3 volume data on the host
disk_device:                ex: "/dev/sdb"
filesystem_map: [ {"dev" : "{{ disk_device }}", "fstype" : "ext4", "path" : "/var/lib/docker"} ]

Dependencies
------------
packages: python, python-pip
pip package: docker-py

Notes
-----
Additional tasks for docker_container module: 
1. expose ports when network_mode is not host
    ports:
      - "8081:8081"
2. add environments variables (ex. INSTALL4J_ADD_VM_PARAMS default value)
    env:
      INSTALL4J_ADD_VM_PARAMS="-Xms1200m -Xmx1200m -XX:MaxDirectMemorySize=2g -Djava.util.prefs.userRoot=/nexus-data/javaprefs"


Example Playbook
----------------
