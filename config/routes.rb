Rails.application.routes.draw do
  scope :api, defaults: { format: :json} do
    resources :foos, except: [:new, :edit]
    resources :bars, except: [:new, :edit]
    resources :cities, only: [:index, :show]
    resources :states, only: [:index, :show]
  end

  get '/ui' => 'ui#index'
  get '/ui#' => 'ui#index'
  root 'ui#index'
 end
