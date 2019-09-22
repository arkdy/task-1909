# Task A
# Write a rake task to populate the DB with 100,000 users randomly distributed
# across time zones in US, Europe and Asia. For each user, generate 1,000
# answers. The answer records should have the created_at timestamps distributed
# over the last 6 months, and be randomly correct

require 'csv'

namespace :data do
  desc "Populate DB with users and answers"
  task :populate => :environment do

    timezones = Timezone.ids
    USERS_QTY = 100_000
    ANSWERS_QTY = 1_000
    DATE_RANGE = 6.month.ago..Time.current
    DATE_FORMAT = '%Y-%m-%d %H:%M:%S'

    CSV.open("db/csv/users.csv", "wb") do |csv|

      (1..USERS_QTY).each do |user_id|
        csv << [user_id, "user#{user_id}", timezones.sample, Time.current.strftime(DATE_FORMAT), Time.current.strftime(DATE_FORMAT)]
      end

    end

    puts "✅ Users generated"


    answer_id = 0
    CSV.open("db/csv/answers.csv", "wb") do |csv|

      # create answers records
      (1..USERS_QTY).each do |user_id|

        ANSWERS_QTY.times do
          answer_id += 1
          csv << [answer_id, user_id, [0, 1].sample, rand(DATE_RANGE).strftime(DATE_FORMAT), Time.current.strftime(DATE_FORMAT)]
        end

        print "Answers for user #{user_id} of #{USERS_QTY}\r"
      end

    end

    puts "✅ Answers generated"


    # Enable loading from file
    ActiveRecord::Base.connection.execute("SET GLOBAL local_infile = 'ON';")

    # clear users table
    ActiveRecord::Base.connection.execute("TRUNCATE users;")
    # Loading from generated CSV
    ActiveRecord::Base.connection.execute("LOAD DATA LOCAL INFILE 'db/csv/users.csv'
                                           INTO TABLE users
                                           FIELDS TERMINATED BY ','
                                           LINES TERMINATED BY '\n'
                                           (id,name,timezone_id,created_at,updated_at)")

    puts "✅ Users populated"


    # clear answers table
    ActiveRecord::Base.connection.execute("TRUNCATE answers;")
    # Loading from generated CSV
    ActiveRecord::Base.connection.execute("LOAD DATA LOCAL INFILE 'db/csv/answers.csv'
                                           INTO TABLE answers
                                           FIELDS TERMINATED BY ','
                                           LINES TERMINATED BY '\n'
                                           (id,user_id,correct,created_at,updated_at)")

    puts "✅ Answers populated"

  end
end
