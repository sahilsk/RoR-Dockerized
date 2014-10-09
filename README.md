[http://sahilsk.github.io/articles/rubyonrails-app-on-docker-part-i-understanding-specs/](http://sahilsk.github.io/articles/rubyonrails-app-on-docker-part-i-understanding-specs/)


Deployment using Docker
========================

Assumption: RoR app name is "dailyReport"
Docker dockerfile namespace "myDockerfiles"


### Mysql:

Run mysqld-safe

	$	docker run -d --name mysql -p 3306:3306 dockerfile/mysql
	
Run mysql

	$	docker run -it --rm --link mysql:mysql dockerfile/mysql bash -c 'mysql -h $MYSQL_PORT_3306_TCP_ADDR'


### Build base dockerfile : `myDockerfiles/ruby_base`
		
	$ docker build -t myDockerfiles/base_ruby .

### Build application dockerfile (main):

myDockerfiles/dailyreport

	#Build main dailyReport 

	$  docker build -t myDockerfiles/dailyreport .
	
### Setup db schema and run migrations


    $ docker run -it --rm  -p 49173:80  -v /var/run/mysqld:/var/run/mysqld:ro --restart="always" -e "RAILS_ENV=production"  stackexpress/dailyreport /bin/bash

	[ root@d5e83dd3fe8e:/opt/dailyReport {master *} ]$ echo $RAILS_ENV
	production
	[ root@d5e83dd3fe8e:/opt/dailyReport {master *} ]$ rake db:create db:migrate db:seed
	dailyReport_production already exists
	== 20140930055148 AddSessionsTable: migrating =================================
	-- create_table(:sessions)
	   -> 0.1364s
	-- add_index(:sessions, :session_id, {:unique=>true})
	   -> 0.1810s
	-- add_index(:sessions, :updated_at)
	   -> 0.1283s
	== 20140930055148 AddSessionsTable: migrated (0.4461s) ========================

	[ root@d5e83dd3fe8e:/opt/dailyReport {master *} ]$ rails generate active_record:session_migration
	   identical  db/migrate/20140930055148_add_sessions_table.rb
	[ root@d5e83dd3fe8e:/opt/dailyReport {master *} ]$ RAILS_ENV=production rake  db:migrate
	[ root@d5e83dd3fe8e:/opt/dailyReport {master *} ]$ exit
