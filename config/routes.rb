#coding: utf-8
# GraphsController
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

Shirokane::Application.routes.draw do
  namespace :admin do
    resources :settings
  end

  #get "home/index"
  #get "graph/index"
  #管理画面用
  namespace :admin do
    resources :login
    resources :users
    resources :graphs
    resources :groups
    resources :home
    resources :groupgraphs do
      member do
        get 'list'
      end
    end
#    resources :groupdashboards do
#      member do
#        get 'list'
#      end
#    end
    root 'home#index'
  end
    
  resources :login
  resources :users
  resources :graphs do
    member do
      get 'csvexport'
    end
  end

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'dashboards#index'
end
