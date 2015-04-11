Rails.application.routes.draw do
  root 'concierge_services#index'

  resources :concierge_services, only: :index
  
  resources :reservations, only: [:new, :create, :show, :destroy] do
    member do
      get 'print_ticket'
      get 'print_lockers'
    end
    collection do
      get 'search'
      get 'searching'
    end
  end
end
