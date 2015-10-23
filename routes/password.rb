#!/usr/bin/ruby

require 'sinatra/base'

module Sinatra
  module MemberApp
    module Routing
      module Password
        def self.registered(app)
          app.get "/password", :auth => :user do
            haml :password
          end
          
          app.post "/password", :auth => :user do
            begin
              if(params['new_password'] != params['repeat_new_password']) then
                @status_message = "New passwords do not match."
                haml :password
              else
                change_password @user, params['old_password'], params['new_password']
                add_log_entry @member_id, "Password Changed"
                @status_message = "Password change successful."
                haml :password
              end
            rescue Exception => e
              @status_message = "Password change failed: #{e}."
              haml :password
            end
          end
        end
      end
    end
  end
end

