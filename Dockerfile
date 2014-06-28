FROM phusion/baseimage:latest
ENV DEBIAN_FRONTEND noninteractive

# Set timezone
RUN ln -sf /usr/share/zoneinfo/Australia/Melbourne /etc/localtime
RUN dpkg-reconfigure tzdata

# Set locale
RUN locale-gen en_AU.UTF-8
RUN dpkg-reconfigure locales
RUN update-locale LANG=en_AU.UTF-8
ENV LC_ALL en_AU.UTF-8
ENV LANG en_AU.UTF-8
ENV LANGUAGE en_AU.UTF-8

# Install packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y patch gawk g++ gcc make libc6-dev patch libreadline6-dev zlib1g-dev \
    libssl-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev \
    automake libtool bison pkg-config libffi-dev

# Create app user
RUN addgroup --gid 9999 app
RUN adduser --uid 9999 --gid 9999 --disabled-password --gecos 'Application' app
RUN usermod -L app

# # Install RVM
RUN su -l app -c 'curl -sSL https://get.rvm.io | bash'
RUN su -l app -c 'rvm autolibs 2; rvm install ruby-2.1.2'
