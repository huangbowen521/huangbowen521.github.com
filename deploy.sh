#!/bin/bash
rake generate && rake deploy
git add -A

git ci -m "$1"
git push origin source
