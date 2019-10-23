Rails.application.routes.draw do
  root to: 'finder#index'

  get 'find_out', to: 'finder#find_out'
end
