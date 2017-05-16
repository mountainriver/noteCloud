```
vi /etc/pam.d/system-auth
auth        required      pam_env.so
auth       required        pam_tally2.so even_deny_root deny=3 unlock_time=120
```
注意:
1、顺序不要错，一定要在pam_env.so后面
2、deny：拒绝次数
3、even_deny_root：包含root用户
4、unlock_time：解锁时间

手动解除锁定：
查看某一用户错误登陆次数：
pam_tally –user
例如，查看work用户的错误登陆次数：
pam_tally –user work
清空某一用户错误登陆次数：
pam_tally –user –reset
例如，清空 work 用户的错误登陆次数，
pam_tally –user work –reset faillog -r 命令亦可。
