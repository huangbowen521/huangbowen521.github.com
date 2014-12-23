#! /bin/zsh
ruby -v
/usr/local/rvm/rubies/ruby-1.9.3-p547/bin/rake generate 
/usr/local/rvm/rubies/ruby-1.9.3-p547/bin/rake sync_post
/usr/local/rvm/rubies/ruby-1.9.3-p547/bin/rake deploy
/usr/local/rvm/rubies/ruby-1.9.3-p547/bin/rake weibo
/usr/local/rvm/rubies/ruby-1.9.3-p547/bin/rake linkedin
git add -A

git ci -m "$1"
git push origin source
