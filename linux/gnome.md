# 界面优化
## 去标题栏
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
