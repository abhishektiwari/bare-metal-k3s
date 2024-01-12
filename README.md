# Bare metal Kubernetes using k3s
Instead of virtual machines (VMs), deploy a production-grade Kubernetes cluster directly on bare metal servers. We will use [k3s](https://k3s.io) along with [k3sup](https://github.com/alexellis/k3sup). K3s is a lightweight Kubernetes distribution and probably easiest and fastest way to setup a Kubernetes cluster in HA mode.

**Install Prerequisite:**
* Install [k3sup](https://github.com/alexellis/k3sup) on your machine. You can use the installer on MacOS and Linux, or visit the Releases page to download the executable for Windows.
* Servers have been already created and initialized using a Ubuntu (22.04/20.0) or Debian (12/11) server operating system. Everything have been tested using Ubuntu (22.04).
* Make sure server host names are unique, otherwise K3s clustering process will fail. If not go to `nano /etc/hostname` and change each node to have unique host name.

**Minimum node requirements:**
* CPU: 4c/8t or more
* RAM: 16GB or more
* Disk: 256GB SSD/NVMe or more

**For high-available setup:**
* Minimum 2 or more nodes
* Network connectivity between nodes

Network connectivity between nodes can be private or public although private connectivity is recommended. Please see high-level UFW firewall rules in `bash-templates/ufw-cluster.sh`.

# Step-by-step

## Add files into `data` folder
See `example` files for your reference.

* `cluster-ips.txt` [Required] - List of IPs for `k3s` cluster nodes. Each IP on a new line.
* `cluster-user.txt` [Required] - Cluster user with `sudo` permission to be used for k3s installation via SSH. It assumes that authorization keys for SSH is already uploaded to host server.
* `cf-token.env` [Required] - For DNS01 challenge to issue Let's Encrypt Certificates for DNS zone hosted by Cloudflare DNS.
* `google-oidc-config.env` [Required] - For Traefik Forward Auth to protect various dashboards including Traefik, Grafana, etc.
* `google-oidc-secrets.env` [Required] - For Traefik Forward Auth to protect various dashboards including Traefik, Grafana, etc.

## Update k3s-chart values
Rename `example.values.yaml` to `values.yaml` and modify values according to your requirements. Basically this files needs a list of domain names and ACME contact email to provision Let's Encrypt Certificates.

## Generate user data file
Execute `output.sh` which will create `init.sh`, `k3s.sh` and `kubectl.sh` scripts.

```
bash output.sh
```

**Generated scripts:**
* Execute `init.sh` to apply additional firewall changes and install a few apt packages to host servers. You can copy this file to host servers and execute.
* Execute `k3s.sh` to install K3S. Script takes Local SSH key (`$HOME/.ssh/id_ed25519`) for provisioning the cluster. After cluster is created script will save the `kubeconfig` in root directory.
* Execute `kubectl.sh` to apply various Kubernetes manifest files and create resources to enable observability on cluster as well allow Traefik Forward Auth, etc.

# Location of kubeconfig
`kubeconfig` will be saved to directory where you ran `k3s.sh`.

```
export KUBECONFIG=/Users/../../k3s/kubeconfig
kubectl config use-context default
kubectl get node -o wide
```


