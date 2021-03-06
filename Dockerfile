FROM  mcr.microsoft.com/dotnet/core/aspnet:2.2
LABEL maintainer="Azure App Services Container Images <appsvc-images@microsoft.com>"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-utils \
        unzip \
        openssh-server \
        vim \
        curl \
        wget \
        tcptraceroute \
        sudo \
        net-tools 

RUN echo "root:Docker!" | chpasswd \
    && echo "cd /DotNetCoreAspNet" >> /etc/bash.bashrc

COPY DotNetCoreAspNet/bin/Debug/netcoreapp2.2/publish /DotNetCoreAspNet
COPY init_container.sh /bin/
RUN chmod 755 /bin/init_container.sh

# configure startup
COPY sshd_config /etc/ssh/
COPY ssh_setup.sh /tmp
RUN chmod -R +x /tmp/ssh_setup.sh \
   && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null) \
   && rm -rf /tmp/* \
   && chmod a+w /etc/ssh/sshd_config \
   && groupadd -r dotnet && useradd -m -g dotnet dotnet\
   && echo "dotnet   ALL=(ALL:ALL) NOPASSWD: /usr/sbin/service ssh start,/usr/sbin/service ssh stop, /usr/sbin/service ssh status, /etc/init.d/ssh start, /etc/init.d/ssh stop, /etc/init.d/ssh status" >> /etc/sudoers\
   && cd /DotNetCoreAspNet \
   && chown -R dotnet:dotnet .\
   && chmod 644 * 


ENV PORT 8080
ENV SSH_PORT 2222
EXPOSE 8080 2222

ENV WEBSITE_ROLE_INSTANCE_ID localRoleInstance
ENV WEBSITE_INSTANCE_ID localInstance
ENV PATH ${PATH}:/home/site/wwwroot
ENV ASPNETCORE_URLS=
ENV ASPNETCORE_FORWARDEDHEADERS_ENABLED=true

USER dotnet
WORKDIR /home/site/wwwroot

ENTRYPOINT ["/bin/init_container.sh"]