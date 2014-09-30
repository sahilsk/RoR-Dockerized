RAILS_ENV=$RAILS_ENV
: ${RAILS_ENV:="development"}
export RAILS_ENV

SECRET_KEY_BASE=$SECRET_KEY_BASE
: ${SECRET_KEY_BASE:="f38c575fcf0a2b0e7c7f002a873d54d78104581ebe069bf2b1afad04014d1e10245b259b872b0e12189ef2ce3fca4c73a9b5103aaf4aad1f4"}
export SECRET_KEY_BASE=$SECRET_KEY_BASE

## Setting DB
DB_NAME="dailyReport_${RAILS_ENV}"
#DATABASE_URL="mysql2://root:root@localhost/${DB_NAME}"

echo "Stopping  unicorn_rails, if already running"
pkill unicorn_rails
echo "cleaning tmp files"
rm -rf tmp/*
echo "Restart Reverse Proxy"
service nginx restart
echo "Running unicorn"
bundle exec unicorn_rails -c /etc/dailyReport/unicorn.rb -E $RAILS_ENV -d
