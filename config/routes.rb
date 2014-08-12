Rails.application.routes.draw do
  root 'pages#index'
  get '/status/:service' => 'pages#status', as: 'status'
end