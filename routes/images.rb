#!/usr/bin/ruby

require 'sinatra/base'
require 'sequel'

module Sinatra
  module MemberApp
    module Routing
      module Images
        def self.registered(app)
          app.get '/images', :auth => :user do
            halt 403 if !is_ops?
            @images = @db[:images]
            haml :images
          end
          
          app.get '/images/:id', :auth => :user do
            halt 403 if !is_ops?
            images = @db[:images].where(:id => params['id'])
            halt 404 if images.empty?
            content_type :png
            images.first[:image]
          end
        end
      end
    end
  end
end

