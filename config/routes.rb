Combogen::Application.routes.draw do
  resources :lists
  resources :combos
  resources :tricks
  resources :tricking_styles

  devise_for :trickers, :controllers => { :registrations => "registrations" },
              :path_names => { :sign_up => "register", :sign_in => "login", :sign_out => "logout"}

  get "welcome/index"

  match '/generate_options' => 'combos#generate_options', :as => 'generate_options'
  match '/generate_custom' => 'combos#generate_custom', :as => 'generate_custom'
  match '/generate_random' => 'combos#generate_random', :as => 'generate_random'
  # match '/order_by_combos' => 'tricks#order_by_combos', :as => 'order_by_combos'

  authenticated :tricker do
    root :to => "combos#index"
  end
  root :to => 'welcome#index'
  
end
