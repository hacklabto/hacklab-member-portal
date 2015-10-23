#!/usr/bin/ruby

require 'sinatra/base'

module Sinatra
  module MemberApp
    module Routing
      module Members
        def self.registered(app)          
          app.get '/members', :auth => :user do
            halt 403 if !is_ops?
            @members = @db[:members]
            haml :members
          end

          app.get '/members/:id', :auth => :user do
            halt 403 if @member_id != params['id'].to_i && !is_ops?
            @member_info = @db[:members].where(:id => params['id']).first
            @waivers = @db[:waivers].select(:id, :name, (@db[:waiver_signatures].select(:id).where(:member_id => params[:id])).as("signed") )
            @log_entries = @db[:log_entries].join(:log_entry_types, :log_entry_types__id => :type_id).where(:member_id => params[:id])
            haml :member
          end
        end
      end
    end
  end
end

