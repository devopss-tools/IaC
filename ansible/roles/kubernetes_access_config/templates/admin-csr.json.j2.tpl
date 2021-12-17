{
  "CN": "admin",
  "hosts": [
      {% for host in groups['k8s-master-group'] %}"{{ hostvars[host].ansible_host }}",{% endfor %}

      {% for host in groups['k8s-master-group'] %}"{{ host }}",{% endfor %}

      "127.0.0.1",
      "kubernetes.default"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "MD",
      "L": "Chishinau",
      "O": "Kubernetes",
      "OU": "Cluster",
      "ST": "Chishinau"
    }
  ]
}
