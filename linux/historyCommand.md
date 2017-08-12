export USER_IP=`who -u am i|awk '{print $NF}'`
export HISTTIMEFORMAT="[%F %T] `whoami` $USER_IP"
