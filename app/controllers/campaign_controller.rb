# These lines load Sinatra and a helper tool to reload the server
# when we have changed the file.
require 'sinatra/base'
require 'sinatra/reloader'

# You will want to require your data model class here
require "database_connection"

require "campaigns_table"
require "campaign_entity"
require "users_table"
require "user_entity"

class CampaignController < Sinatra::Base
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

  def campaigns_table
    $global[:campaigns_table] ||= CampaignsTable.new($global[:db])
  end

  # Start your server using `rackup`.
  # It will sit there waiting for requests. It isn't broken!

  # YOUR CODE GOES BELOW THIS LINE

  get '/campaign/new' do
    if !session.key?(:user_id)
      error_msg = "error_msg=You have to log in first!"
      redirect "/catboard/error?#{error_msg}"
    elsif users_table.get(session[:user_id]).advertiser == 'f'
      error_msg = "error_msg=You cannot do this from this account!"
      redirect "/catboard/error?#{error_msg}"
    else
      erb :'campaign/new'
    end
  end

end
