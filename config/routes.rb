Rails.application.routes.draw do
  resources :cities, except: [:new, :edit]
  scope :api, defaults: { format: :json} do
    resources :foos, except: [:new, :edit]
    resources :bars, except: [:new, :edit]
    resources :cities, only: [:index, :show]
  end

  get '/ui' => 'ui#index'
  get '/ui#' => 'ui#index'
  root 'ui#index'
 end
