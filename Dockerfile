FROM  phusion/baseimage:latest
ENV   DEBIAN_FRONTEND noninteractive

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
    automake libtool bison pkg-config libffi-dev monit nginx git

# Create app user
RUN addgroup --gid 9999 app
RUN adduser --uid 9999 --gid 9999 --disabled-password --gecos 'Application' app
RUN usermod -L app

# Install ruby
RUN su -l app -c 'curl http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz > /tmp/ruby-2.1.2.tar.gz'
RUN su -l app -c 'cd /tmp; tar zxf ruby-2.1.2.tar.gz'
RUN su -l app -c 'cd /tmp/ruby-2.1.2; ./configure --prefix=$HOME/.ruby --disable-install-rdoc'
RUN su -l app -c 'cd /tmp/ruby-2.1.2; make'
RUN su -l app -c 'cd /tmp/ruby-2.1.2; make install'
RUN su -l app -c 'echo "export PATH=/home/app/.ruby/bin:$PATH" >> ~/.profile'
RUN su -l app -c 'gem update --system -N'
RUN su -l app -c 'gem uninstall rubygems-update'
RUN su -l app -c 'gem install bundler puma -N'
RUN chown -R app:app /home/app
