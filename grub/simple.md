### 文件结构
- /boot/grub/grub.cfg	这个是grub的配置文件，但是不用去修改他，他是运行`grub update`时根据下面的文件**自动生成**的
- /etc/default/grub 这里是Grub的基本配置
- /etc/grub.d/00_header    这是保留给Grub使用的
- /etc/grub.d/05_debian_theme    这是和主题风格相关的，在这里面调用了上面我们提到的grub_background.sh
- /etc/grub.d/10_linux    这是和Linux系统相关的启动项
- /etc/grub.d/20_linux_xen    同上
- /etc/grub.d/30_os-prober    这是系统自动检测出的其他系统的启动项
- /etc/grub.d/40_custom    这里写自定义配置
- /etc/grub.d/41_custom    同上
- /usr/share/desktop-base/grub_background.sh    这个是和背景图片、颜色相关的配置，被上边的05_debian_theme调用
- /usr/share/images/desktop-base/    这里存放了Grub的背景图片，另外还有GDM和桌面的背景图片
### 更改字体
1. `grub-mkfont -s 24 -o unicode.pf2 自己喜欢的字体.ttf`  
【24 为字体大小，可自己调整】之后在当前文件夹下会有unicode.pf2文件，确保上述命令没有报错，要是文件大小太小就换个字体文件吧。
2. 将unicode.pf2文件移动到/boot/grub/font ，替换原有的unicode.pf2
3. 重启即可见到效果。若想还原/boot/grub下有个unicode.pf2复制到font文件夹下替换就好。
