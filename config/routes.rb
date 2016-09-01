Rails.application.routes.draw do
  get '/shot', to: 'screenshot#shot'
end
