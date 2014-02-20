#!/bin/bash
rake generate && rake deploy
git add -A
git ci -m "$0"
git pull
git push origin source
