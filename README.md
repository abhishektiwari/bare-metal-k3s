# Bare metal Kubernetes using k3s
Instead of virtual machines (VMs), deploy a production-grade Kubernetes cluster directly on bare metal servers. We will use [k3s](https://k3s.io) along with [k3sup](https://github.com/alexellis/k3sup). K3s is a lightweight Kubernetes distribution and probably easiest and fastest way to setup a Kubernetes cluster in HA mode.

**Install Prerequisite:**
* [k3sup](https://github.com/alexellis/k3sup). You can also use the installer on MacOS and Linux, or visit the Releases page to download the executable for Windows.
* Servers have been already created and their bare state.

**Minimum node requirements:**
* CPU: 4c/8t or more
* RAM: 16GB or more
* Disk: 256GB SSD/NVMe or more

**For high-available setup:**
* Minimum 2 or more nodes
* Network connectivity between nodes

Network connectivity between nodes can be private or public although private connectivity is recommended.

# Step-by-step

## Add files into `data` folder
See `example` files for your reference.

* `cluster-ips.txt` [Required] - List of IPs for `k3s` cluster nodes. Each IP on a new line.
* `cluster-user.txt` [Required] - Cluster user to be used for k3s installation
* `cf-token.env` [Required] - For DNS01 challenge using Cloudflare
* `google-oidc.env` [Required] - For Traefik Forward Auth to protect various Dashboards

## Generate user data file
Run,

```
bash output.sh
```

Use `init.sh` file when provisioning Kubernetes cluster nodes. Depending on your provider, either copy paste the file content or upload it to a secure location and use the URL as part of cloud-init (when creating node) or post installation script (after creating node). 

# Location of kubeconfig
`kubeconfig` will be saved to directory where you ran `k3sup` commands.

# Test your cluster

```
export KUBECONFIG=/Users/abhishektiwari/Labs/k3s/kubeconfig
kubectl config use-context default
kubectl get node -o wide
```

# Node names
Make sure node names are unique. Go to `nano /etc/hostname` and change each node to have unique host name.

# After install check hostname for each node

```
hostname -I
```


#

cd k3s-chart
helm template --dry-run . | awk -vout=../manfiests -F": " '$0~/^# Source: /{file=out"/"$2; print "Creating "file; system ("mkdir -p $(dirname "file"); echo -n "" > "file)} $0!~/^#/ && $0!="---"{print $0 >> file}'