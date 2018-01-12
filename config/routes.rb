require 'sidekiq/web'

Districtcomain::Application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  get :admin, to: redirect('admins/projects')
  get :admins, to: redirect('admins/projects')
  
  namespace :admins do
    resources :projects
    resources :bids
    resources :tariffs
    resource :blog, only: :show do
      resources :articles
      resources :articles_cats
    end
    resources :team_members
    get :exports, to: 'companies#index'
    post :exports, to: 'companies#export'
    match :imports, to: 'companies#import', via: [:get, :post]
  end

  devise_for :admins, module: 'admins', skip: [:registrations]

  devise_for :managers, module: 'managers', skip: [:registrations],
                        path_names: {
                          sign_in: 'login',
                          sign_out: 'logout'
                        }
  
  namespace :managers do
    resources :projects, only: [:index, :show, :update], id: /\d+/
    post 'ajax/projects', to: 'projects#filter_projects'
  end

  devise_for :users, module: 'users', controllers: { confirmations: 'users/confirmations' }
  
  devise_scope :user do
    controller 'users/sessions' do
      post 'ajax/signin', to: :create
      delete 'ajax/signout', to: :destroy
    end

    controller 'users/registrations' do
      get 'join_us', to: :new
      post 'ajax/signup', to: :create
    end

    controller 'users/passwords' do
      post 'restore_password', to: :restore
      post 'update_password', to: :update_password
      post 'ajax/recover', to: :ajax_update
    end
  end

  controller :mains do
    get 'main/sign_success', to: :register_end
    post 'ajax/filterCompanies', to: :filter_companies
    post 'ajax/checkAddress', to: :check_address
    post 'ajax/getHints', to: :get_hints
  end

  controller :settings do
    get :settings, to: :index
    post 'ajax/saveCompany', to: :update
    post 'ajax/saveProfile', to: :profile_update
    post 'ajax/uploadCompany', to: :upload_avatar
    post 'ajax/uploadCompanyPic', to: :upload_gallery
    post 'ajax/deletePic', to: :delete_pic
    post 'ajax/sortPics', to: :sort_pic
    post 'ajax/addSocial', to: :add_social
    post 'ajax/setNewCoords', to: :set_new_coords
    post 'ajax/setNewZoom', to: :set_new_zoom
  end

  controller :payments do
    get :payments, to: :index
    post 'payments/managed', to: :managed
    post 'payments/account', to: :account
    post 'ajax/setMakerType', to: :set_maker_type
    post 'ajax/setTariff', to: :set_tariff
    post 'ajax/payTariff', to: :pay_tariff
  end

  get :company, to: 'companies#show'

  constraints Subdomain do
    get '/', to: 'companies#show'
  end

  resources :projects, except: :new, id: /\d+/ do
    resources :bids do
      get :revise, on: :member
      get :complete, on: :member
      post :win, on: :member
      post :dispute, on: :member
      post :deliver_project, on: :member
    end
  end

  controller :projects do
    get 'post_project', to: :new, as: :new_project
    post 'ajax/filterProjects', to: :filter_projects
    post 'ajax/searchProjects', to: :search
  end

  controller :bids do
    post 'ajax/chatMessages', to: :chat_messages, as: :chat_messages
    post 'ajax/createChatMessage', to: :create_chat_message, as: :create_chat_message
  end

  controller :blogs do
    get 'blog', to: :index, as: :blog
    get 'blog/tag/:tag', to: :tag, as: :blog_tag
    get 'blog/:section/:article', to: :article, as: :blog_section_article
    get 'blog/:section', to: :section, as: :blog_section
    post 'blog/ajax/share', to: :share
  end

  controller :pages do
    get :about
    get :contacts
    get :tomorrowear

    %w( terms privacy work investors ).each do |page|
      get page, to: :show, page: page
    end

    post 'ajax/feedBack', to: :feedback
  end

  %w( 404 422 500 ).each do |code|
    get code, to: 'errors#show', code: code
  end

  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'mains#index'
end
