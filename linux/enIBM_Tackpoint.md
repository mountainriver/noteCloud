#debian8 下用的新配置文件，有效。  
1. 旧的配置文件是/etc/X11/xorg.conf
2. 新的配置文件是/usr/share/X11/xorg.conf.d/10-endev.conf 中的
```
Section "InputClass"
        Identifier "evdev pointer catchall"
        MatchIsPointer "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
        Option      "Emulate3Buttons"     "true"
        Option      "Emulate3TimeOut"     "50"
        Option      "EmulateWheel"        "on"
        Option      "EmulateWheelTimeOut" "200"
        Option      "EmulateWheelButton"  "2"
        Option      "YAxisMapping"        "4 5"
        Option      "XAxisMapping"        "6 7"
        Option      "ZAxisMapping"        "4 5"
EndSection
```
