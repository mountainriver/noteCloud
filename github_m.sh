#/bin/bash
echo -e "\033[32mGithub working...\033[0m"
echo -e "\033[32mAdding all change...\033[0m"
git add -A
echo -e "\033[32mCommiting...\033[0m"
git commit -m "$1"
echo -e "\033[32mPushing...\033[0m"
git push
echo -e "\033[32mDone.\033[0m"
