# These lines load Sinatra and a helper tool to reload the server
# when we have changed the file.
require 'sinatra/base'
require 'sinatra/reloader'

# You will want to require your data model class here
require "database_connection"

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

  def users_table
    $global[:users_table] ||= UsersTable.new($global[:db])
  end

  # Start your server using `rackup`.
  # It will sit there waiting for requests. It isn't broken!

  # YOUR CODE GOES BELOW THIS LINE

  get '/' do
    redirect '/catboard'
  end

  get '/catboard' do
    erb :'catboard/index', locals: { 
      cat_ads: cat_ads_table.list
    }
  end

  get '/catboard/new' do
    if !session.key?(:user_id)
      error_msg = "error_msg=You have to log in first!"
      redirect "/catboard/error?#{error_msg}"
    elsif users_table.get(session[:user_id]).advertiser == 't'
      error_msg = "error_msg=You cannot do this from this account!"
      redirect "/catboard/error?#{error_msg}"
    else
      erb :'catboard/new'
    end
  end

  get '/catboard/error' do
    erb :error, locals: { error_msg: params[:error_msg] }
  end

  post '/catboard' do
    target = ''
    if params[:file]
      tempfile = params[:file][:tempfile]
      filename = params[:file][:filename]
      target = "public/uploads/#{filename}"
      File.open(target, 'wb') { |f| f.write tempfile.read }
    end

    server_path = target[6..]
    cat_ads_table.add(CatAdEntity.new(
      title: params[:title],
      description: params[:description],
      image_url: params[:file] ? server_path : "uploads/default.png",
      user_id: session[:user_id],
      posted_on: DateTime.now
    ))
    redirect '/catboard'
  end

  get '/catboard/:index' do
    ad = cat_ads_table.get(params[:index].to_i)
    cat_owner = users_table.get(ad.user_id)
    sightings = sightings_table.list(params[:index].to_i)
    erb :'/catboard/details', locals: {
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
    erb :'catboard/edit', locals: {
      index: cat_ad_index,
      cat_ad: cat_ads_table.get(cat_ad_index),
    }
  end

  patch '/catboard/:index' do
    cat_ad_index = params[:index].to_i
    target = ''
    if params[:file]
      tempfile = params[:file][:tempfile]
      filename = params[:file][:filename]
      target = "public/uploads/#{filename}"
      File.open(target, 'wb') { |f| f.write tempfile.read }
    end

    server_path = target[6..]
    cat_ad = cat_ads_table.get(cat_ad_index)
    cat_ads_table.update(
      index: cat_ad_index,
      title: params[:title],
      description: params[:description],
      image_url: params[:file] ? server_path : cat_ad.image_url,
      posted_on: DateTime.now
    )
    redirect '/catboard'
  end

  get '/catboard/:index/sighting' do
    cat_ad = cat_ads_table.get(params[:index])
    if !session.key?(:user_id)
      error_msg = "error_msg=You have to log in first!"
      redirect "/catboard/error?#{error_msg}"
    elsif users_table.get(session[:user_id]).advertiser == 't'
      error_msg = "error_msg=You cannot do this from this account!"
      redirect "/catboard/error?#{error_msg}"
    elsif cat_ad.user_id == session[:user_id]
      error_msg = "error_msg=You cannot add sightings to your own ad!"
      redirect "/catboard/error?#{error_msg}"
    else      
      erb :'catboard/sighting', locals: {
        cat_ad: cat_ad
      }
    end
  end

  post '/catboard/:index/sighting/new' do
    cat_ad = cat_ads_table.get(params[:index])
    sighting = SightingEntity.new(
      location: params[:location], 
      details: params[:details], 
      user_id: session[:user_id], 
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
    erb :'catboard/sighting_edit', locals: {
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

  get '/catboard/my/ads' do
    erb :'catboard/index', locals: { 
      cat_ads: cat_ads_table.list_by_user_id(session[:user_id])
    }
  end
end
