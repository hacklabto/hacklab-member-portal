#!/usr/bin/ruby

require 'sinatra/base'
require 'sequel'

module Sinatra
  module MemberApp
    module Routing
      module Waivers
        def self.registered(app)
          # routes to manage waivers themselves
          app.get '/waivers' do
            @waivers = @db[:waivers]
            # TODO: don't hardcode the active status #
            @waiver_signatures = @db[:waiver_signatures].join(:members, :members__id => :member_id).where(:status => 4).group_by(:waiver_id)
            haml :waivers
          end
          
          app.get '/waivers/:id' do
            @waiver_content = @db[:waivers].where(:id => params['id']).first[:content]
            haml :waiver
          end

          # routes to handle signing waivers
          app.get '/waivers/:waiver_id/sign/:member_username' do
            @waiver_content = @db[:waivers].where(:id => params['waiver_id']).first[:content]
            @member_username = params['member_username']
            haml :waiver_sign
          end
          
          app.post '/waivers/:waiver_id/sign/:member_username' do
            member_sigimage = datauri_extract(params['member_sigdata'])
            witness_sigimage = datauri_extract(params['witness_sigdata'])

            member_id = @db[:members].where(:username => params['member_username']).first[:id]
            witness_id = @db[:members].where(:username => params['witness_username']).first[:id]
            raise NameError, 'Member or witness does not exist.' if !member_id or !witness_id

            @db.transaction do
              member_sig_id = @db[:images].insert(:image => member_sigimage)
              witness_sig_id = @db[:images].insert(:image => witness_sigimage)
              @db[:waiver_signatures].insert(
                :waiver_id => params[:waiver_id],
                :member_id => member_id,
                :member_sigimage_id => member_sig_id,
                :witness_id => witness_id,
                :witness_sigimage_id => witness_sig_id,
                :signed_from_ip => request.ip
              )
              redirect to "/members/#{member_id}"
            end
          end
        end
      end
    end
  end
end

