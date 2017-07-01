# 查看
1. ls -l /dev/
crw-rw----  1 root       dialout 188,   0 Jun 30 10:13 ttyUSB0
2. lsusb
Bus 006 Device 002: ID 0403:6001 Future Technology Devices International, Ltd FT232 USB-Serial (UART) IC
3. dmesg | grep tty
[  376.436201] usb 6-1: FTDI USB Serial Device converter now attached to ttyUSB0
# 使用minicom
1. sudo minicom -s 配置
2. sudo minicom 直接进入
3. 快捷键：
- 组合键的用法是：先按Ctrl+A组合键，然后松开这两个键，再按Z键。另外还有一些常用的组合键。
- (1)S键：发送文件到目标系统中;
- (2)W键：自动卷屏。当显示的内容超过一行之后，自动将后面的内容换行。这个功能在查看内核的启动信息时很有用。
- (3)C键：清除屏幕的显示内容;
- (4)B键：浏览minicom的历史显示;
- (5)X键：退出mInicom，会提示确认退出。

