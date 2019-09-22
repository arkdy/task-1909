class PeriodAccuracyPresenter < ApplicationPresenter

  attr_reader :user,
              :from_date,
              :to_date

  def initialize(params)
    @user = User.find_by(name: params[:username])
    @from_date = params[:from_date]
    @to_date = params[:to_date]
  end

  def overall_accuracy
    "#{@user&.overall_accuracy&.round}%"
  end

  def date_range_accuracy
    "#{@user&.date_range_accuracy(@from_date, @to_date)&.round}%"
  end

end