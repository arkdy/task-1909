Rails.application.routes.draw do
  root to: 'home#index'
  get 'period_accuracy', to: 'home#period_accuracy'
  get 'weekly_rankings', to: 'home#weekly_rankings'
end
