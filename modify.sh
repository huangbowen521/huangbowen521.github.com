#!/bin/bash
rake generate 
rake deploy
git add -A
message=$1
if [ -z "$message" ]; then
	message="modify"
fi
git ci -m "$message"
git push origin source
