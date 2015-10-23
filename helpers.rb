require 'net/ldap'
require 'base64'
require 'digest'

module Sinatra
  module MemberApp
    module Helpers
      def password_ok?(username, password)
        ldap = Net::LDAP.new :host => settings.ldap['auth_host']
        ldap.auth settings.ldap['bind_string'].sub('USERNAME', username), password
        ldap.bind
      end
      
      def hash_password(password)
        salt = 16.times.inject('') {|t| t << rand(16).to_s(16)}
        "{SSHA}" + Base64.encode64("#{Digest::SHA1.digest("#{password}#{salt}")}#{salt}").chomp
      end
      
      def change_password(username, old_password, new_password)
        bind_dn = settings.ldap['bind_string'].sub('USERNAME', username)
        ldap = Net::LDAP.new :host => settings.ldap['change_host'], :port => 636, :encryption => :simple_tls
        ldap.auth(bind_dn, old_password)
        raise RuntimeError, "Current password is incorrect" if !ldap.bind
        raise RuntimeError, "Unable to change password: #{ldap.get_operation_result.message}" if !ldap.replace_attribute(bind_dn, 'userPassword', new_password)
      end
      
      def is_user?
        @user != nil
      end
      
      def is_ops?
        settings.ops_users.include? @user
      end
      
      def add_log_entry(member_id, entry_type, msg = nil)
        entry_type_id = @db[:log_entry_types].where(:type => entry_type).first[:id]
        p entry_type_id
        p @db[:log_entries].insert(
          :member_id => member_id,
          :type_id => entry_type_id,
          :content => msg
        )
      end
      
      def datauri_extract(uri)
        Base64.decode64(uri.split(",")[1])
      end
    end
  end
end
