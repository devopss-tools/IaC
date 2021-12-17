{
  "CN": "system:node:{{ ansible_currentHost_fact_hostname }}",
  "hosts": [
      {% for host in groups['etcd-group'] %}"{{ hostvars[host].ansible_host }}",{% endfor %}

      {% for host in groups['etcd-group'] %}"{{ host }}",{% endfor %}

      "127.0.0.1",
      "etcd.default"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "MD",
      "L": "Chishinau",
      "O": "etcd",
      "OU": "Cluster",
      "ST": "Chishinau"
    }
  ]
}
