# These lines load Sinatra and a helper tool to reload the server
# when we have changed the file.
require 'sinatra/base'
require 'sinatra/reloader'

# You will want to require your data model class here
require "database_connection"

require "users_table"
require "user_entity"
require "campaigns_table"
require "campaign_entity"

class UserController < Sinatra::Base
  # This line allows us to send HTTP Verbs like `DELETE` using forms
  use Rack::MethodOverride

  enable :sessions

  configure :development do
    # In development mode (which you will be running) this enables the tool
    # to reload the server when your code changes
    register Sinatra::Reloader
    set :views, "app/views"
    set :public_dir, "public"

    # In development mode, connect to the development database
    db = DatabaseConnection.new("localhost", "web_application_dev")
    $global = { db: db }
  end

  configure :test do
    set :views, "app/views"
    set :public_dir, "public"
    # In test mode, connect to the test database
    db = DatabaseConnection.new("localhost", "web_application_test")
    $global = { db: db }
  end

  def users_table
    $global[:users_table] ||= UsersTable.new($global[:db])
  end

  # Start your server using `rackup`.
  # It will sit there waiting for requests. It isn't broken!

  # YOUR CODE GOES BELOW THIS LINE

  get '/users/signup' do
    erb :'users/signup', locals: { 
      user: session[:user_id]
    }
  end

  post '/users' do
    user = UserEntity.new(
      email: params["email"],
      name: params["name"],
      password: params["password"],
      mobile: params["mobile"],
      advertiser: params["advertiser"]
    )
    session[:user_id] = users_table.add(user)
    redirect '/users/profile'
  end

  get '/users/profile' do
    user = users_table.get(session[:user_id])
    erb :'users/profile', locals: { user: user }
  end

  get '/users/login' do
    erb :'users/login'
  end

  post '/users/login' do
    user = users_table.find_by(email: params[:email], password: params[:password])
    if user
      session[:user_id] = user.id
      redirect '/catboard'
    end
    redirect '/users/login'
  end

  get '/users/logout' do
    session.clear
    redirect '/catboard'
  end

  get '/users/profile/:index/edit' do
    user = users_table.get(params[:index])
    erb :'users/profile_edit', locals: { user: user }
  end

  patch '/users/profile/:index' do
    users_table.update(
      index: params[:index],
      email: params[:email],
      name: params[:name],
      password: params[:password],
      mobile: params[:mobile],
      advertiser: params[:advertiser]       
    )
    redirect "/users/profile"
  end

end
