Combogen::Application.routes.draw do
  resources :lists
  resources :combos, :except => :show
  resources :tricks do
    get '/fetch_combos' => 'tricks#fetch_combos', :as => 'fetch_combos'
  end
  resources :tricking_styles

  devise_for :trickers, :controllers => { :registrations => "registrations" }
  resources  :trickers, :only => :show

  get "welcome/index"

  match '/my_combos' => 'combos#my_combos', :as => 'my_combos'
  match '/generate_options' => 'combos#generate_options', :as => 'generate_options'
  match '/generate_custom' => 'combos#generate_custom', :as => 'generate_custom'
  match '/generate_random' => 'combos#generate_random', :as => 'generate_random'

  get '/get_generator_view' => 'combos#get_generator_view'

  authenticated :tricker do
    root :to => "combos#index"
  end
  root :to => 'welcome#index'
  
end
