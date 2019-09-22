class User < ApplicationRecord
  belongs_to :timezone
  has_many :answers do
    def date_range
      # scope :date_range, ->(date_from, date_to, timezone) { where(created_at: DateTime.parse(date_from)..DateTime.parse(date_to)) }
    end
  end
end
