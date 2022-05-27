# These lines load Sinatra and a helper tool to reload the server
# when we have changed the file.
require 'sinatra/base'
require 'sinatra/reloader'

# You will want to require your data model class here
require "database_connection"
# require "animals_table"
# require "animal_entity"

require "cat_ads_table"
require "cat_ad_entity"
require "users_table"

class CatboardController < Sinatra::Base
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

  def cat_ads_table
    $global[:cat_ads_table] ||= CatAdsTable.new($global[:db])
  end

  # Start your server using `rackup`.
  # It will sit there waiting for requests. It isn't broken!

  # YOUR CODE GOES BELOW THIS LINE

  get '/catboard' do
    erb :'catboard/catboard_index', locals: { 
      cat_ads: cat_ads_table.list
    }
  end

  get '/catboard/new' do
    erb :'catboard/catboard_new'
  end

  post '/catboard' do
    cat_ads_table.add(CatAdEntity.new(
      title: params[:title],
      description: params[:description],
      image_url: params[:image_url] == " " ? nil : params[:image_url],
      user_id: session[:user_id]
    ))
    redirect '/catboard'
  end

  delete '/catboard/:index' do
    cat_ads_table.remove(params[:index].to_i)
    redirect '/catboard'
  end

  get '/catboard/:index/edit' do
    cat_ad_index = params[:index].to_i
    erb :'catboard/catboard_edit', locals: {
      index: cat_ad_index,
      cat_ad: cat_ads_table.get(cat_ad_index)
    }
  end

  patch '/catboard/:index' do
    cat_ad_index = params[:index].to_i
    cat_ads_table.update(
      index: cat_ad_index, 
      title: params[:title],
      description: params[:description],
      image_url: params[:image_url]
    )
    redirect '/catboard'
  end

  # EXAMPLE ROUTES

  get '/animals' do
    erb :'catboard/animals_index', locals: { animals: animals_table.list }
  end

  get '/animals/new' do
    erb :'catboard/animals_new'
  end

  post '/animals' do
    animal = AnimalEntity.new(params[:species])
    animals_table.add(animal)
    redirect '/animals'
  end

  delete '/animals/:index' do
    animals_table.remove(params[:index].to_i)
    redirect '/animals'
  end

  get '/animals/:index/edit' do
    animal_index = params[:index].to_i
    erb :'catboard/animals_edit', locals: {
      index: animal_index,
      animal: animals_table.get(animal_index)
    }
  end

  patch '/animals/:index' do
    animal_index = params[:index].to_i
    animals_table.update(animal_index, params[:species])
    redirect '/animals'
  end
end
