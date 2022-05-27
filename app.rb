# app.rb

require "sinatra/base"
require "json"

require "./app/controllers/user_controller"
require "./app/controllers/catboard_controller"

class WebApplicationServer < Sinatra::Base
  use CatboardController
  use UserController
  get "/" do
    ""
  end
end
