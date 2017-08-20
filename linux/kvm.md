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
