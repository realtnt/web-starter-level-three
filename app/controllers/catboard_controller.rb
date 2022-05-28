# These lines load Sinatra and a helper tool to reload the server
# when we have changed the file.
require 'sinatra/base'
require 'sinatra/reloader'

# You will want to require your data model class here
require "database_connection"
# require "animals_table"
# require "animal_entity"

require "date"

require "cat_ads_table"
require "cat_ad_entity"
require "users_table"
require "sighting_entity"
require "sightings_table"

class CatboardController < Sinatra::Base
  use Rack::MethodOverride
  enable :sessions
  
  configure :development do
    register Sinatra::Reloader
    set :views, "app/views"
    set :public_dir, "public"
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

  def sightings_table
    $global[:sightings_table] ||= SightingsTable.new($global[:db])
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

  get '/catboard/:index' do
    ad = cat_ads_table.get(params[:index].to_i)
    users_table = UsersTable.new($global[:db])
    cat_owner = users_table.get(ad.user_id)
    sightings = sightings_table.list(params[:index].to_i)
    erb :'/catboard/catboard_details', locals: {
      cat_ad: ad,
      cat_owner: cat_owner,
      sightings: sightings
    }
  end

  delete '/catboard/:index' do
    cat_ads_table.remove(params[:index].to_i)
    redirect '/catboard'
  end

  get '/catboard/:index/edit' do
    cat_ad_index = params[:index].to_i
    erb :'catboard/catboard_edit', locals: {
      index: cat_ad_index,
      cat_ad: cat_ads_table.get(cat_ad_index),
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

  get '/catboard/:index/sighting' do
    cat_ad = cat_ads_table.get(params[:index])
    erb :'catboard/catboard_sighting', locals: {
      cat_ad: cat_ad
    }
  end

  post '/catboard/:index/sighting/new' do
    cat_ad = cat_ads_table.get(params[:index])
    sighting = SightingEntity.new(
      location: params[:location], 
      details: params[:details], 
      user_id: cat_ad.user_id, 
      cat_ad_id: params[:index],
      spotted_on: params[:spotted_on], 
      posted_on: DateTime.now, 
      id: nil
    )
    sightings_table.add(sighting)
    redirect "/catboard/#{params[:index]}"
  end

  delete '/catboard/:ad_index/sighting/:index' do
    sightings_table.remove(params[:index])
    redirect "/catboard/#{params[:ad_index]}"
  end

  get '/catboard/:ad_index/sighting/:index' do
    cat_ad = cat_ads_table.get(params[:ad_index])
    sighting = sightings_table.get(params[:index])
    erb :'catboard/catboard_sighting_edit', locals: {
      cat_ad: cat_ad,
      sighting: sighting
    }
  end

  patch '/catboard/:ad_index/sighting/:index' do
    cat_ad = cat_ads_table.get(params[:ad_index])
    sightings_table.update(
      index: params[:index],
      location: params[:location], 
      details: params[:details], 
      user_id: cat_ad.user_id, 
      cat_ad_id: params[:ad_index],
      spotted_on: params[:spotted_on], 
      posted_on: DateTime.now
    )
    redirect "/catboard/#{params[:ad_index]}"
  end
end
