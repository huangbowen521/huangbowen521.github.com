#!/bin/bash
ruby -v
rake generate 
rake deploy
rake weibo
rake sync_post
rake linkedin
git add -A
message=$1
if [ -z "$message" ]; then
	message="new post"
fi
git ci -m "$message"
git push origin source
