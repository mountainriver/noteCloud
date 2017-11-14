# vim
此项目的目的是配置一个基于VIM的PYTHON开发环境。
方式是通过VIMRC配置和安装插件。

>备注：1.F5一键运行有时VIM会显示空白。 :redraw! 强制重绘可临时解决。
# INSTALL
## windows
1. 安装VIM，或则下载vim64.
2. git clone vundle,或者下载下来，放到vim/vimfiles/下
3. 配置vim/_vimrc 
4. 安装插件
5. 有乱码，powerline字体？
## linux
cd ~/.vim/
git clone vunble
# notice
- airline不显示箭头，需要安装fonts-powerline(需要刷新字体缓存，或重启)
- 不想启用vimrc，可以使用 `vim -u NORC`
- 查看vimrc使用顺序，用`vim --version`;`vim; :version`
