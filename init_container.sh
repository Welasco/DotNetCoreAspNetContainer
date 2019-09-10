#!/usr/bin/env bash
sudo cat >/etc/motd <<EOL 
  _____                               
  /  _  \ __________ _________   ____  
 /  /_\  \\___   /  |  \_  __ \_/ __ \ 
/    |    \/    /|  |  /|  | \/\  ___/ 
\____|__  /_____ \____/ |__|    \___  >
        \/      \/                  \/ 
A P P   S E R V I C E   O N   L I N U X

Documentation: http://aka.ms/webapp-linux
Dotnet quickstart: https://aka.ms/dotnet-qs
.NETCore runtime version: `ls -X /usr/share/dotnet/shared/Microsoft.NETCore.App | tail -n 1`

EOL
cat /etc/motd

# Get environment variables to show up in SSH session
sudo eval $(printenv | sed -n "s/^\([^=]\+\)=\(.*\)$/export \1=\2/p" | sed 's/"/\\\"/g' | sed '/=/s//="/' | sed 's/$/"/' >> /etc/profile)

# starting sshd process
sudo sed -i "s/SSH_PORT/$SSH_PORT/g" /etc/ssh/sshd_config
sudo service ssh start

appPath="/home/site/wwwroot"
runFromPath="/tmp/webapp"
startupCommandPath="/opt/startup/startup.sh"
defaultAppPath="/DotNetCoreAspNet/DotNetCoreAspNet.dll"
userStartupCommand="$@"

# When run from copy is enabled, Oryx tries to run the app from a different directory (local to the container),
# so sanitize any input arguments which still reference the wwwroot path. This is true for VS Publish scenarios.
# Even though VS Publish team might fix this on their end, end users might not have upgraded their extension, so
# this code needs to be present.
#if [ "$APP_SVC_RUN_FROM_COPY" = true ]; then
#    # Trim the ending '/'
#    appPath=$(echo "${appPath%/}")
#    runFromPath=$(echo "${runFromPath%/}")
#    userStartupCommand=$(echo $userStartupCommand | sed "s!$appPath!$runFromPath!g")
#    runFromPathArg="-runFromPath $runFromPath"
#fi
#
#oryxArgs="-appPath $appPath -output $startupCommandPath -defaultAppFilePath $defaultAppPath \
#    -bindPort $PORT -userStartupCommand '$userStartupCommand' $runFromPathArg"
#
#echo "Running oryx $oryxArgs"
#eval oryx $oryxArgs
#$startupCommandPath

dotnet $defaultAppPath