#!/bin/bash
rake generate 
rake sync_post
rake deploy
rake weibo
git add -A

git ci -m "$1"
git push origin source
