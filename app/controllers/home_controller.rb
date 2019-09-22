class HomeController < ApplicationController
  def index;
  end

  def period_accuracy
    @page = PeriodAccuracyPresenter.new(params)
  end

  def weekly_rankings
    @page = WeeklyRankingsPresenter.new(params)
  end

end
