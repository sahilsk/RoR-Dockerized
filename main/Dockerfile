#
# dailyReport in Container
#
 
# Pull base image.
FROM  stackexpress/base_ruby
 

# Fill dependencies for mysql2 gem
RUN apt-get install -y libmysqlclient-dev libmysqlclient18 ruby-dev
 
# Install Nginx.
RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y nginx && \
  rm -rf /var/lib/apt/lists/* && \
  chown -R www-data:www-data /var/lib/nginx

# Pull repository from private github repos
 
### Create .ssh dir in home directory
RUN mkdir -p /root/.ssh
# Add your private key here. (Create a separate key, so that you can revoke it later)
ADD ./id_rsa /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
 

# Setup Reverse Proxy
ADD ./dailyReport_nginx.conf /etc/nginx/sites-enabled/default
RUN service nginx reload && service nginx restart

 
WORKDIR /opt/dailyReport

# Pull project : Replace with your github handle and repository
RUN git clone git@github.com:sahilsk/dailyReport.git .
 
# Install gem
RUN gem install bundler
RUN bundle install
RUN rbenv rehash

# Pre-compile app production assets
RUN RAILS_ENV=production bundle exec rake assets:precompile
 
# Add unicorn config
ADD ./unicorn.rb /etc/dailyReport/unicorn.rb

# Run script
ADD ./run.sh /etc/dailyReport/run.sh


# Define mountable directories.
VOLUME ["/etc/dailyReport", "/var/log/dailyReport", "/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"] 

# Expost port 80
EXPOSE 80

# Set environment variables
ENV RAILS_ENV development

#
CMD /bin/bash /etc/dailyReport/run.sh