#!/usr/bin/ruby

require 'sinatra/base'

module Sinatra
  module MemberApp
    module Routing
      module Auth
        def self.registered(app)
          app.get "/login" do
            haml :login
          end
          
          app.get "/logout" do
            session[:username] = nil
            redirect to '/login'
          end
 
          app.post "/login" do
            if(password_ok?(params['username'], params['password'])) then
              session[:username] = params['username']
              member_info = @db[:members].join(:member_statuses, :member_statuses__id => :status).select(:member_statuses__status, :members__id___member_id).where(:username => params['username']).first
              session[:member_status] = member_info[:status]
              session[:member_id] = member_info[:member_id]
              redirect to '/'
            else
              redirect to '/login'
            end
          end
        end
      end
    end
  end
end

