Rails.application.routes.draw do
  get "/is_up",       to: "application#is_up"
  post "/graphql",    to: "graphql#execute"
  post "/photos",     to: "photos#create"
  get "/photos/:id",  to: "photos#show", :as => :photo

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
