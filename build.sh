#!/bin/sh
rm -rf _book
echo "Start building the gitbook!"
gitbook build
cd _book
echo "Init a git repo, and create gh-pages branch."
git init 
git checkout --orphan gh-pages
git add .
echo "commit gitbook file"
git commit -m "Auto publisher"
git remote add origin https://github.com/laniakea1990/Docker-Log-Collector.git 
echo "push gh-pages branch to origin"
git push --force -u origin gh-pages > /dev/null 2>&1
