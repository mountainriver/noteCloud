Windows中默认的文件格式是GBK(gb2312)，而Linux一般都是UTF-8)
# 查看文件编码
file xxx
# 只是解决VIM查看文件乱码问题
在~/.vimrc 中添加 set encoding=utf-8 fileencodings=ucs-bom,utf-8,cp936 
# 编码转换
1. vim 中
set fileencoding=utf-8
2. 直接转换文件
iconv -f GBK -t UTF-8 file1 -o file2
