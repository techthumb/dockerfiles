FROM  phusion/baseimage:latest
ENV   DEBIAN_FRONTEND noninteractive
RUN   echo "hello world" > /etc/motd
