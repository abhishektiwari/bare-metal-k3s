# Bare metal Kubernetes using k3s
Instead of virtual machines (VMs), deploy a production-grade Kubernetes cluster directly on bare metal servers. We will use [k3s](https://k3s.io) along with [k3sup](https://github.com/alexellis/k3sup). K3s is a lightweight Kubernetes distribution and probably easiest and fastest way to setup a Kubernetes cluster in HA mode.

**Install Prerequisite:**
* Install [k3sup](https://github.com/alexellis/k3sup) on your machine. You can use the installer on MacOS and Linux, or visit the Releases page to download the executable for Windows.
* Servers have been already created and initialized using a Ubuntu (22.04/20.04) or Debian (12/11) server operating system. Everything have been tested using Ubuntu (22.04).
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
Execute `generate-init.sh` (*Optional*) and `generate-k3s.sh`. This will create a set of files to configure hosts, bootstrap Kubernetes cluster using K3s, apply some basic manifests and helm charts to newly created cluster.

```
bash generate-init.sh
bash generate-k3s.sh
```
### Output from `generate-init.sh`
These files need to be executed remotely on the host as `sudo` user.

* `init.sh` to apply additional configuration to hosts including firewall changes and install a few apt packages. You can copy this file to host servers and execute.
* `cloudflared.sh` [*Optional*] to install [remotely managed Cloudflare tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel/) on each host to [securely SSH](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/use-cases/ssh/) and access Kubernetes [control plane](https://developers.cloudflare.com/cloudflare-one/tutorials/kubectl/) behind the firewall.
* `cloudflared-sshd.sh` [*Optional*] to setup SSH using Cloudflare short-lived certificate which can be used to render the [SSH console in the browser](https://developers.cloudflare.com/cloudflare-one/tutorials/kubectl/).


To enabled Cloudflare tunnel, 

### Output from `generate-k3s.sh`
* Execute `k3s.sh` to install K3S. Script takes local SSH key (e.g. `$HOME/.ssh/id_ed25519`) for provisioning the cluster. After cluster is created script will save the `kubeconfig` in root directory.
* Execute `kubectl.sh` to apply various Kubernetes manifest files and create resources 
    * to enable observability on cluster
    * to expose dashboards for Traefik, Grafana, Prometheus.
    * to add add Traefik Forward Auth to protect dashboards behind Google Authentication

# Location of kubeconfig
`kubeconfig` will be saved to directory where you ran `k3s.sh`.

```
export KUBECONFIG=/Users/../../k3s/kubeconfig
kubectl config use-context default
kubectl get node -o wide
```


