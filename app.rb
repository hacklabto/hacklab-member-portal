#!/usr/bin/ruby2.0

require 'haml'
require 'sinatra/base'
require 'sinatra/config_file'

require_relative 'helpers'

require_relative 'routes/auth'
require_relative 'routes/waivers'
require_relative 'routes/members'
require_relative 'routes/images'
require_relative 'routes/log'
require_relative 'routes/password'

class MemberApp < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :sessions => true
  register Sinatra::ConfigFile
  config_file 'config.yaml'
  configure do
    mime_type :png, 'image/png'
  end
  set :db_handle => Sequel.connect(settings.db_url)
  
  # home page
  get '/' do
    redirect "/login" unless is_user?
    haml :index
  end

  # authentication system
  register do
    def auth(type)
      condition do
        redirect "/login" unless send("is_#{type}?")
      end
    end
  end

  before do
    @db = settings.db_handle
    @user = session[:username]
    @member_id = session[:member_id]
    @member_status = session[:member_status]
  end

  helpers Sinatra::MemberApp::Helpers
  
  register Sinatra::MemberApp::Routing::Auth
  register Sinatra::MemberApp::Routing::Waivers
  register Sinatra::MemberApp::Routing::Members
  register Sinatra::MemberApp::Routing::Images
  register Sinatra::MemberApp::Routing::Log
  register Sinatra::MemberApp::Routing::Password
end

