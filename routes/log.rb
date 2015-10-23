#!/usr/bin/ruby

require 'sinatra/base'
require 'sequel'

module Sinatra
  module MemberApp
    module Routing
      module Log
        def self.registered(app)
          app.get '/log', :auth => :user do
            halt 403 if !is_ops?
            @log_entries = @db[:log_entries].join(:log_entry_types, :log_entry_types__id => :type_id).join(:members, :members__id => :log_entries__member_id)
            haml :log_entries
          end
        end
      end
    end
  end
end

