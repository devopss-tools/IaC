# Development Infrastructure
###### Makefile to deploy ansible playbooks


### Development and Runtime environment

---------------------------------------------------------------------

 To install ansible automatically in your environment:
```bash
make configure
```

*source ./bin/python_env/bin/activate*

To exit the virtual environment, you can use:

*deactivate*

#### Manual Configuration

- OS Linux (tested on CentOS Linux release 7.4.1708 and Ubuntu 18/20 )
  - TODO : test for Win+Cygwin
- GNU Make (tested on version GNU Make 3.82 - 4.2.1)
- Ansible  https://www.ansible.com/
    - Install ansible
      1. using appropriate package manager to install virtualenv *yum install python-virtualenv -y*
      2. create python virtual environment (we take *python_env* like a name for our virtual environment) *virtualenv python_env*
      3. activate  *source ./python_env/bin/activate*
      4. testing if python binary is a link in our virtualenv *which python*  
      5. upgrade python package manager  *pip install --upgrade pip*
      6. install ansible 2.9 directly fron tar.gz file *pip  install  https://releases.ansible.com/ansible/ansible-2.9.9.tar.gz*
      7. check if ansible package exists in local pip data base *pip freeze*
      8. check the version of ansible *ansible --version*
      9. create simple inventory file *echo 127.0.0.1 >inv*
      10. invoke ansible for final check  *ansible all -m "ping" -i inv -c local* the output should be like
         *127.0.0.1 | SUCCESS => {
         "changed": false,
         "ping": "pong"
          }*
     11. deactivate the virtualenv  *deactivate*  
Support OpenSource!


### Makefile commands to deploy ansible playbooks

---------------------------------------------------------------------
###### Run onace
###### Run everytime run new terminal
```bash
source ./bin/python_env/bin/activate
```

```bash
make help
```
