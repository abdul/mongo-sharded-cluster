FROM abdul/alpine-mongo:latest
MAINTAINER abdul.qabiz@gmail.com
ARG mongod_config
ARG startup_script
ADD ${mongod_config} /etc/mongod.conf
ADD ${startup_script} /root/startup.sh
CMD ["sh","/root/startup.sh"]