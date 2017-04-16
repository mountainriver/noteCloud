#/bin/bash
echo "Adding all change..."
git add -A
echo "Commiting..."
git commit -m "$1"
echo "Pushing..."
git push
