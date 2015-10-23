require 'net/ldap'
require 'base64'

module Sinatra
  module MemberApp
    module Helpers
      def password_ok?(username, password)
        ldap = Net::LDAP.new
        ldap.auth settings.ldap_bind_string.sub('USERNAME', username), password
        ldap.bind
      end
      
      def is_user?
        @user != nil
      end
      
      def is_ops?
        settings.ops_users.include? @user
      end
      
      def datauri_extract(uri)
        Base64.decode64(uri.split(",")[1])
      end
    end
  end
end
