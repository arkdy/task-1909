# README

## Setup

1. bundle
2. setup DB creds in .env.local
3. rails db:setup
4. mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root --force mysql
5. rails s