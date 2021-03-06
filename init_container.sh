#!/usr/bin/env bash

# Get environment variables to show up in SSH session
# eval $(printenv | sed -n "s/^\([^=]\+\)=\(.*\)$/export \1=\2/p" | sed 's/"/\\\"/g' | sed '/=/s//="/' | sed 's/$/"/' >> /etc/profile)

# starting sshd process
cp /etc/ssh/sshd_config /tmp
sed -i "s/SSH_PORT/$SSH_PORT/g" /tmp/sshd_config
cp /tmp/sshd_config /etc/ssh/sshd_config

# sed -i "s/SSH_PORT/$SSH_PORT/g" /etc/ssh/sshd_config
sudo /usr/sbin/service ssh start

if [ -f "/DotNetCoreAspNet/DotNetCoreAspNet.dll" ]; then
  # generate fresh rsa key
  cd /DotNetCoreAspNet
  defaultAppPath="/DotNetCoreAspNet/DotNetCoreAspNet.dll"
fi

if [ -f "/Angular/Angular.dll" ]; then
  # generate fresh rsa key
  cd /Angular
  defaultAppPath="Angular.dll"
fi

# defaultAppPath="/DotNetCoreAspNet/DotNetCoreAspNet.dll"

dotnet $defaultAppPath