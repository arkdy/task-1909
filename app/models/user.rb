class User < ApplicationRecord
  belongs_to :timezone

  # scope which gets answers for user between given dates and respecting user's timezone
  has_many :answers do
    def in_range(from_date, to_date)
      where("convert_tz(created_at, 'UTC', '#{@association.owner.timezone}') BETWEEN '#{from_date}' AND '#{to_date}'")
    end
  end
end
