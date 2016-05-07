FROM abdul/alpine-mongo:latest
MAINTAINER abdul.qabiz@gmail.com
ADD mongod.conf /etc/mongod.conf
ADD startup.sh /root/startup.sh
CMD ["sh","/root/startup.sh"]