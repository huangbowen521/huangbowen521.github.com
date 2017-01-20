#!/bin/bash
ruby -v
rake generate 
rake sync_post
rake deploy
rake weibo
rake linkedin
git add -A
message=$1
if [ -z "$message" ]; then
	message="new post"
fi
git ci -m "$message"
git push origin source
