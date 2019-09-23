# README

## Setup

0. `git clone git@github.com:arkdy/task-1909.git `
0. `cd task-1909`
1. `bundle`
2. `mv .env.example .env.local`, setup DB creds in `.env.local`
3. `rails db:setup`
4. Enable named timezones in MySQL `mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root --force mysql`
5. Populate DB `rake data:populate` 
6. `rails s`

## Possible improvements

1. Write fixtures, models and integration tests
2. Implement validation of the form user input
3. Cache aggregated values, rankings in separate tables/views

