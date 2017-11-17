# 界面优化
## 去标题栏
1. 改配置文件
	> debian8下有效，升级到9以后，失效
	
	gnome3顶部有一栏标题栏，而最大化的时候，标题栏也占了一行，这样就感觉很不爽了，解决方法如下：
	1. root登录
	3. vim /usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml
	4. 找到  
	`<frame_geometry name=”max” title_scale=”medium” parent=”normal” rounded_top_left=”false” rounded_top_right=”false”>`  
	修改为  
	`<frame_geometry name=”max” title_scale=”medium” parent=”normal” rounded_top_left=”false” rounded_top_right=”false” has_title=”false”>`
	5. 往下几行，找到  
	`<distance name=”title_vertical_pad” value=”9″/>`  
	将9改成0。
	7. 按Alt+F2，输入r，回车就可以看到效果了。
2. 安装gnome插件
	maximus-ng
	//maximus-two
## 其他插件
- Dash to dock
- Drop down terminal
- Applications menu
- Netspeed
- Openwather
- User themes
## 主题
- Global Dark Theme
- Numix
