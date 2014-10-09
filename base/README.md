**Build Image**

    docker pull sahilsk/ruby

Run container

    root@pblin050:/opt/dockerize/base# docker run -it --rm sahilsk/ruby /bin/bash
    [ root@9f7acba75316:~ ]$ ruby -v
    ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-linux]
    [ root@9f7acba75316:~ ]$ rbenv -v
    rbenv 0.4.0-98-g13a474c
    [ root@9f7acba75316:~ ]$


Update ruby version, if required

    root@pblin050:/opt/dockerize/base# docker run -it sahilsk/ruby /bin/bash
     [ root@9f7acba75316:~ ]$ ruby -v
    [ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-linux]
     [ root@9f7acba75316:~ ]$ rbenv install -l
      ...
     2.1.2
     2.1.3
     2.1.3
      ...
    [ root@9f7acba75316:~ ]$ rbenv install 2.1.3
    Downloading ruby-2.1.3.tar.gz...
    -> http://dqw8nmjcqpjn7.cloudfront.net/0818beb7b10ce9a058cd21d85cfe1dcd233e98b7342d32e9a5d4bebe98347f01
    Installing ruby-2.1.3..
    Installed ruby-2.1.3 to /usr/local/rbenv/versions/2.1.3
    [ root@9f7acba75316:~ ]$ ruby -v
    ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-linux]
    [ root@9f7acba75316:~ ]$ rbenv local 2.1.3
    [ root@9f7acba75316:~ ]$ rbenv global 2.1.3
    [ root@9f7acba75316:~ ]$ ruby -v
    ruby 2.1.3p242 (2014-09-19 revision 47630) [x86_64-linux]


Commit container and create updated image

      docker commit  -m "ruby updated to 2.13"  myDockerfiles/ruby2.1.3



Dockerfile
-----------------------

        #
    # Ruby 2.1.2 via rbenv 
    #
    
    # Pull base image.
    FROM dockerfile/ubuntu	
    
    # Install some dependencies
    RUN apt-get update
    RUN apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties
    
    # Install rbenv to install ruby
    RUN git clone git://github.com/sstephenson/rbenv.git /usr/local/rbenv
    RUN echo '# rbenv setup' > /etc/profile.d/rbenv.sh
    RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
    RUN echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
    RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
    RUN chmod +x /etc/profile.d/rbenv.sh
    
    # Install rbenv plugin: ruby-build
    RUN mkdir /usr/local/rbenv/plugins
    RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
    
    # Let's not copy gem package documentation
    RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
    
    ENV RBENV_ROOT /usr/local/rbenv
    ENV PATH $RBENV_ROOT/bin:$RBENV_ROOT/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    
    # Install ruby
    RUN rbenv install 2.1.2
    RUN rbenv local 2.1.2
    RUN rbenv global 2.1.2
    
    
    ## Install Rails
    RUN apt-get install -y software-properties-common
    RUN add-apt-repository ppa:chris-lea/node.js
    RUN apt-get update
    RUN apt-get install -y nodejs
    
    ## Finally, install Rails
    RUN gem install rails
    RUN rbenv rehash
    
    CMD ["/bin/bash"]
