class User < ApplicationRecord
  belongs_to :timezone

  has_many :answers

  # returns percents number
  def date_range_accuracy(from_date, to_date)
    User.find_by_sql("SELECT count(CASE WHEN correct=1 THEN 1 END)/count(*)*100 AS accuracy
                      FROM answers
                      WHERE user_id=#{id}
                      AND convert_tz(created_at, 'UTC', '#{timezone}') BETWEEN '#{from_date}' AND '#{to_date}'")
                      .first[:accuracy]
  end

  # returns percents number
  def overall_accuracy
    User.find_by_sql("SELECT count(CASE WHEN correct=1 THEN 1 END)/count(*)*100 AS accuracy
                      FROM answers WHERE user_id=#{id}")
                      .first[:accuracy]
  end

end
