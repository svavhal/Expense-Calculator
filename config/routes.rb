Rails.application.routes.draw do
  
  root 'dashboard#index'

  devise_for :users, :controllers => {:registrations => "registrations"}

  resources :groups do
    resources :bills
  end

  resources :members

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
