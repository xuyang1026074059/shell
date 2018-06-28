#本文档仅适用于单master 节点的kubernetes-1.10 安装部署
#不建议使用kubeadm模式安装部署生产环境，因为kubeadm 初始化生成证书存在有限期为1年，到期后所有node节点会自动崩溃，慎重考虑！！！

# ----------安装 k8s 系统基础操作---------------------------------------------------------------------------------------------
func basic_operate()
{
# 解压安装包
	mkdir -p /root/kubernetes-1.10/
	tar -zvxf kubernetes-1.10.tar.gz /root/kubernetes-1.10/
# 永久关闭防火墙
# k8s 1.8 以后必须要关闭swap,不然会导致kubelet 异常，swpoff -a 属于临时关闭。
# 配置操作系统内核参数并且执行sysctl --system 使内核参数立即生效
	systecmts stop firewalld.service
	systemctl disable firewalld.service
    swapoff -a
# 必须修改 /etc/fstab,注释服务器 swap 所在行，下面为案例,然后刷新分区表 mount -a
# age: 
#     “#/dev/mapper/centos-swap swap xfs defaults 0 0”
#      then execute the command line
    mount -a
    free -m
	setenforce 0
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
	cat <<EOF > /etc/sysctl.conf
		net.bridge.bridge-nf-call-ip6tables = 1
		net.bridge.bridge-nf-call-iptables = 1
		net.ipv4.ip_forward = 1
	EOF
	sysctl --system
}

# ----------安装 kube 二进制文件-------------------------------------------------------------------------------------------
func kube_install()
{
# 安装keepealived, keepalived 自己进行在 /etc/keepalived/keepalive.conf 配置
	rpm -ivh /root/kubernetes-1.10/keepalived/*.rpm
# 安装 kube 系列二进制文件到 /usr/bin 目录下，并且赋予权限
    cd /root/kube/
	chmod +x /root/kube/*
	cp -r /root/kube* /usr/bin/
# 安装 docker 并且加载 kubernetes-1.10 所有镜像，包括calico 的镜像
	mkdir -p /var/lib/docker
	chmod +x /root/kubernetes-1.10/docker/*
# 此处必须给 /var/lib/docker 进行分区或者创建逻辑卷
	cp /root/kubernetes-1.10/docker/* /usr/bin/
	cp /root/kubernetes-1.10/docker.service /etc/systemd/system/
	systemctl daemon-reload
	systemctl restart docker.service
	systemctl enable dokcker.service
	docker load -i /root/kubernetes-1.10/kubernetes-1.10.tar
# 安装kubelet，但是并不启动，因为 kubeadm init 会自动拉起kubelet
	mkdir -p /etc/systemd/system/kubelet.service.d
	cp -r /root/kubernetes-1.10/kubelet.service /etc/systemd/system
	cp /root/kubernetes-1.10/10-kubeadm.conf /etc/systemd/system/kubelet.service.d/
	systemctl daemon-reload
	systemctl enable kubelet.service
# 安装 socat, ebtables 离线rpm包
# socat 用来进行端口转发，
	rpm -ivh /root/kubernetes-1.10/rpm/*.rpm
# 安装 cni 插件
	mkdir -p /opt/cni/bin
	tar -zvxf /root/kubernetes-1.10/cni-plugins-amd64-v0.6.0.tgz -C /opt/cni/bin
}


# ---------安装etcd (单master 节点不需要安装启动etcd,高可用节点需要安装启动并且配置10-etcd.conf)-----------------------------
func etcd_install()
{
	chmod +x /root/kubernetes-1.10/etcd/etcd
	chmod +x /root/k8s-1/10/etcd/etcdctl
	cp -r /root/kubernetes-1.10/etcd/etcd /usr/bin/
	cp -r /root/kubernetes-1.10/etcd/etcdctl /usr/bin/
	mkdir -p /etcd/etcd
	cp -r /root/kubernetes-1.10/etcd/10-etcd.conf /etc/etcd/
	cp -r /root/kubernetes-1.10/etcd/etcd.service /usr/lib/systemd/system/
	systemctl daemon-reload
	systemctl enable etcd.serivce
	systemctl restart etcd.service
}

# ----------在 master 节点上进行 kubeadm init 安装---------------------------------------------------------------------------
func master_install()
{
	basic_operate
	kube_install
	etcd_install

# 因为我们用的是 calico 网络，所以 IP 范围是 10.244.0.0/16
	kubeadm init --kubernetes-version=v1.10.0 --pod-network-cidr=10.244.0.0/16 --api-advertise-address=192.168.2.187 >> history.log
# 初始化成功后，会生成token：
#   eg: kubeadm join xxxxxxxxxxxxxxx
# 如果有token, 则证明初始化成功了，执行下面的后续操作
# 保存 kubeadm join xxxxx 到文件中
	mkdir -p $HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	sudo chown $(id -u):$(id -g) $HOME/.kube/config
	kubectl apply -f /root/kubernetes-1.10/calico.yaml
	kubectl get po -n kube-system
# 给 master 节点打标签
	kubectl get node
	kubectl label node xxxx kubernetes.io/role=master
}


# ------node 节点安装---------------------------------------------------------------------------------------------------
func node_install()
{
	basic_operate
	kube_install
# 执行 kubeadm join xxxxxxxxxx
	kubeadm join xxxxxxx
}

func kube_label() 
{
# 执行成功后，在master 节点上给添加成功的node 节点打标签
	kubectl label node xxxx kubernetes.io/role=node
}

func main()
{
	echo "开始安装 k8s-1.10..................."
	read "label？master or node"
	if [ $label x == master x ]; then
		echo "start to install master"
		master_install
	else 
		echo "start to install node"
		node_install
	fi
}
