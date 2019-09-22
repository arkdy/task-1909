class WeeklyRankingsPresenter < ApplicationPresenter

  def initialize(params)
    # you can supply any day of the week
    # and method will calculate week start and week end 'including' this day
    @from_date = params[:from_date]
  end

  # returns array of hashes, ordered by accuracy
  # e.g.
  #     [0] {
  #           :name => 'user11',
  #          :user_id => 11,
  #         :accuracy => 70,
  #           :change => 26
  #     },
  # ....
  def top_users(limit = 100)

    # beginning of the week calculated from the closest monday to the from_date
    # e.g. Mon, 12 Aug 2019 00:00:00 +0000
    week_start = DateTime.parse(@from_date).monday + 7.days

    # end of the week until midnight
    # e.g. Mon, 19 Aug 2019 23:59:59 +0000
    week_end = (week_start + 6.days).end_of_day

    prev_week_start = week_start - 1.week
    prev_week_end = week_end - 1.week

    # get ratings for the current week
    current_week_rating = User.find_by_sql("SELECT name, user_id, count(CASE WHEN correct=1 THEN 1 END)/count(*)*100 AS accuracy
                                            FROM answers, users
                                            WHERE answers.created_at BETWEEN '#{week_start}' AND '#{week_end}'
                                            AND users.id = answers.user_id
                                            GROUP BY user_id ORDER BY accuracy DESC LIMIT #{limit}")

    users_ids = current_week_rating.pluck(:user_id).join(',')

    # get ratings for the selected users for previous week
    prev_week_rating = User.find_by_sql("SELECT user_id, count(CASE WHEN correct=1 THEN 1 END)/count(*)*100 AS accuracy_prev FROM answers
                        WHERE user_id IN(#{users_ids}) AND created_at BETWEEN '#{prev_week_start}' AND '#{prev_week_end}'
                        GROUP BY user_id LIMIT #{limit}")


    # generate results array of hashes
    (current_week_rating + prev_week_rating).group_by(&:user_id).values.map do |arr|
      {
          name: arr.first[:name],
          user_id: arr.first[:user_id],
          accuracy: arr.first[:accuracy].round,
          change: (arr.first[:accuracy] - arr.last[:accuracy_prev]).round
      }
    end

  end

end