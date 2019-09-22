class Answer < ApplicationRecord
  belongs_to :user

  # returns hash of number correct and incorrect answers, e.g. { true => 2, false => 3 }
  scope :accuracy, -> { group(:correct).count }
end
