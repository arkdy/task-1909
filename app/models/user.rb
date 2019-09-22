class User < ApplicationRecord
  belongs_to :timezone

  # scope which gets answers for user between given dates and respecting user's timezone
  has_many :answers do
    def in_range(from_date, to_date)
      where("convert_tz(created_at, 'UTC', '#{@association.owner.timezone}') BETWEEN '#{from_date}' AND '#{to_date}'")
    end
  end

  # you can supply any day of the week
  # and method will calculate week start and week end 'including' this day
  def self.weekly_ranking(from_date, limit = 100)
    # beginning of the week calculated from the closest monday to the from_date
    # e.g. Mon, 12 Aug 2019 00:00:00 +0000
    week_start = DateTime.parse(from_date).monday + 7.days

    # end of the week until midnight
    # e.g. Mon, 19 Aug 2019 23:59:59 +0000
    week_end = (week_start + 6.days).end_of_day

    prev_week_start = week_start - 1.week
    prev_week_end = week_end - 1.week


    current_week_rating = User.find_by_sql("SELECT user_id, count(CASE WHEN correct=1 THEN 1 END)/count(*)*100 AS accuracy
                                            FROM answers
                                            WHERE created_at BETWEEN '#{week_start}' AND '#{week_end}'
                                            GROUP BY user_id ORDER BY accuracy DESC LIMIT #{limit}")

    users_ids = current_week_rating.pluck(:user_id).join(',')

    prev_week_rating = User.find_by_sql("SELECT user_id, count(CASE WHEN correct=1 THEN 1 END)/count(*)*100 AS accuracy_prev FROM answers
                        WHERE user_id IN(#{users_ids}) AND created_at BETWEEN '#{prev_week_start}' AND '#{prev_week_end}'
                        GROUP BY user_id LIMIT #{limit}")

    # getting result array of hashes, ordered by accuracy
    # e.g.
    #     [0] {
    #          :user_id => 11,
    #         :accuracy => 70,
    #           :change => 26
    #     },
    #     [1] {
    #          :user_id => 37,
    #         :accuracy => 69,
    #           :change => 21
    #     },
    #     [2] {
    #          :user_id => 68,
    #         :accuracy => 68,
    #           :change => 31
    #     },
    # ....
    (current_week_rating + prev_week_rating).group_by(&:user_id)
                                            .values.map do |arr| { user_id: arr.first[:user_id],
                                                                   accuracy: arr.first[:accuracy].round,
                                                                   change: arr.first[:accuracy].to_i-arr.last[:accuracy_prev].to_i }
    end

  end

end
