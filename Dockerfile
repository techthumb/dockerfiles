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
RUN apt-get install wget git -y

# Install ruby
WORKDIR /tmp
RUN wget -O ruby-install-0.4.3.tar.gz https://github.com/postmodern/ruby-install/archive/v0.4.3.tar.gz
RUN tar -xzvf ruby-install-0.4.3.tar.gz
WORKDIR /tmp/ruby-install-0.4.3/bin
RUN ./ruby-install ruby 2.1

# Install chruby
WORKDIR /tmp
RUN wget -O chruby-0.3.8.tar.gz https://github.com/postmodern/chruby/archive/v0.3.8.tar.gz
RUN tar -xzvf chruby-0.3.8.tar.gz
WORKDIR /tmp/chruby-0.3.8
RUN make install
RUN echo 'source /usr/local/share/chruby/chruby.sh' > /etc/profile.d/chruby.sh
RUN echo 'chruby 2.1' >> /etc/profile.d/chruby.sh
