# 介绍
KVM是Linux kernel的一个模块，可以用命令modprobe去加载KVM模块。加载了该模块后，才能进一步通过工具创建虚拟机。但是仅有KVM模块是不够的。因为用户无法直接控制内核去做事情，还必须有一个运行在用户空间的工具才行。这个用户空间的工具，kvm开发者选择了已经成型的开源虚拟化软件QEMU。说起来QEMU也是一个虚拟化软件。它的特点是可虚拟不同的CPU。比如说在x86的CPU上可虚拟一个power的CPU，并可利用它编译出可运行在power上的CPU，并可利用它编译出可运行在power上的程序。KVM使用了QEMU的一部分，并稍加改造，就成了可控制KVM的用户空间工具了。所以你会看到，官方提供的KVM下载有两大部分(qemu和kvm)三个文件(KVM模块、QEMU工具以及二者的合集)。也就是说，你可以只升级KVM模块，也可以只升级QEMU工具。这就是KVM和QEMU 的关系。
# 安装
1. 安装KVM qemu
sudo apt-get install qemu-kvm qemu uml-utilities libvirt-bin libvirt-dev
2. 加载内核模块：
modprobe kvm_intel #or kvm_amd
3. 安装图形界面管理工具：
sudo apt-get install virt-manager
4. 添加到开机启动：
systemctl enable libvirtd.service
5. 启动服务：
systemctl restart libvirtd.service
# 创建虚拟机(必须root?)
- 虚拟机主要两个部分：
	1. 镜像文件，格式raw,或则qcow2(支持动态扩张).
	qemu-img create -f qcow2 CentOS1.qcow2 100G
	2. 配置文件，xml(见最后附件)
	3. 配置，启动
    virsh define demo.xml 	//定义,创建虚拟机
	virsh start test_ubuntu 	//启动虚拟机
	virsh vncdisplay test_ubuntu 	//查看虚拟机的vnc端口， 然后就可以通过vnc登录来完成虚拟机的安装

# 常用命令
- 网络
virsh net-list --all
virsh net-start default
- 启动、停止
virsh start hostname
virsh shutdown hostname
- 连接到客户机串口
virsh console hostname
- 非root用户
virsh --connect qemu:///system list --all

# 附件
## .xml
>
<domain type='kvm'>
	<name>test_ubuntu</name> 	//虚拟机名称
	<memory unit='GiB'>4</memory> 	//最大内存
	<currentMemory unit='GiB'>4</currentMemory> 	//可用内存
	<vcpu>8</vcpu> 	//虚拟cpu个数
	<os>
		<type arch='x86_64' machine='pc'>hvm</type>
		<boot dev='cdrom'/> 	//光盘启动
	</os>
	<features>
		<acpi/>
		<apic/>
		<pae/>
	</features>
	<clock offset='localtime'/>
		<on_poweroff>destroy</on_poweroff>
		<on_reboot>restart</on_reboot>
		<on_crash>destroy</on_crash>
	<devices>
		<emulator>/usr/libexec/qemu-kvm</emulator>
		<disk type='file' device='disk'>
			<driver name='qemu' type='qcow2'/>
			<source file='/var/lib/libvirt/images/test.qcow2'/> 	//目的镜像路径
			<target dev='hda' bus='ide'/>
		</disk>
		<disk type='file' device='cdrom'>
			<source file='/var/lib/libvirt/images/ubuntu.iso'/> 	//光盘镜像路径
			<target dev='hdb' bus='ide'/>
		</disk>
		<interface type='bridge'> 	//虚拟机网络连接方式
			<source bridge='kvmbr0'/> 	//当前主机网桥的名称
			<mac address="00:16:3e:5d:aa:a8"/> 	//为虚拟机分配mac地址，务必唯一，否则dhcp获得同样ip,引起冲突
		</interface>
		<input type='mouse' bus='ps2'/>
		<graphics type='vnc' port='-1' autoport='yes' listen = '0.0.0.0' keymap='en-us'/>	//vnc方式登录，端口号自动分配，自动加1，可以通过virsh vncdisplay来查询
	</devices>
</domain>
