systemctl disable firewalld --now

swapoff -a

cat > /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

cat > /etc/sysctl.d/k8s.conf  <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

modprobe overlay
modprobe br_netfilter
sysctl -p /etc/sysctl.d/k8s.conf

cat > /etc/yum.repos.d/k8s.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=0
EOF

yum install containerd.io cri-tools -y

crictl config runtime-endpoint unix:///var/run/containerd/containerd.sock

containerd config default > /etc/containerd/config.toml

sed -i '/registry.mirrors/a \ \ \ \ \ \ \ \ [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]\n\ \ \ \ \ \ \ \ \ \ \ endpoint = ["https://frz7i079.mirror.aliyuncs.com"]' /etc/containerd/config.toml

sed -i 's/registry\.k8s\.io\/pause:3\.6/registry.aliyuncs.com\/google_containers\/pause:3.7/g' /etc/containerd/config.toml

sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml


systemctl enable containerd --now

# proxy
/workspace/clash-for-linux/start.sh
source /etc/profile.d/clash.sh
proxy_on

mkdir -p /workspace/containerd

wget https://github.com/containerd/nerdctl/releases/download/v1.2.0/nerdctl-1.2.0-linux-amd64.tar.gz -O /workspace/containerd/nerdctl-1.2.0-linux-amd64.tar.gz

wget https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz -O /workspace/containerd/cni-plugins-linux-amd64-v1.2.0.tgz

proxy_off

tar Cxzvvf /usr/local/bin/ /workspace/containerd/nerdctl-1.2.0-linux-amd64.tar.gz

mkdir -p /opt/cni/bin/
tar Cxzvvf /opt/cni/bin/ /workspace/containerd/cni-plugins-linux-amd64-v1.2.0.tgz

mkdir /etc/nerdctl/
cat > /etc/nerdctl/nerdctl.toml <<EOF
debug = false
debug_full = false
address = "unix:///var/run/containerd/containerd.sock"
namespace = "k8s.io"
#snapshotter = "stargz"
cgroup_manager = "systemd"
#hosts_dir = ["/etc/containerd/certs.d","/etc/nerdctl/certs.d"]
insecure_registry = false
EOF

mkdir -p /etc/containerd/certs.d/docker.io
cat > /etc/containerd/certs.d/docker.io/hosts.toml <<EOF
server = "https://docker.io"
[host."https://g0v522ip.mirror.aliyuncs.com"]
  capabilities = ["pull","resolve"]
[host."https://docker.mirrors.ustc.edu.cn"]
  capabilities = ["pull","resolve"]
[host."https://registry-1.docker.io"]
  capabilities = ["pull","resolve","push"]
EOF

systemctl restart containerd

yum install -y kubelet-1.26.0-0 kubeadm-1.26.0-0 kubectl-1.26.0-0 --disableexcludes=kubernetes

systemctl enable kubelet --now
