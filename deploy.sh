#! /bin/zsh
ruby -v
rake generate 
rake sync_post
rake deploy
rake weibo
rake linkedin
git add -A

git ci -m "$1"
git push origin source
