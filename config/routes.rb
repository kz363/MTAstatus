Rails.application.routes.draw do
  root 'pages#index'
  get '/status/:service' => 'pages#status'
  get '/reroute/:line' => 'pages#reroute'
end