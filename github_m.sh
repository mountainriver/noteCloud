#/bin/bash

echo -e "\033[32mGithub working...\033[0m"
echo -e "\033[32m0.pulling...\033[0m"
git pull
echo -e "\033[32m1.Adding all change...\033[0m"
git add -A
echo -e "\033[32m2.Commiting...\033[0m"
echo $1
if [ -n "$1" ];then
	git commit -m "$1"
else
	t=`date +%Y/%m/%d-%H%M`
	git commit -m "$t"
fi

echo -e "\033[32m3.Pushing...\033[0m"
git push
echo -e "\033[32mDone.\033[0m"
