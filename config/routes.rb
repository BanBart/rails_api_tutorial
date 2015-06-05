Rails.application.routes.draw do
  namespace :api, defaults: { format: :json },
                              constrainsts: { subdomain: 'api' }, path: '/' do

  end  
end
