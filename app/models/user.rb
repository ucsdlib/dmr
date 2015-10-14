# encoding: utf-8
#---
# @author Vivian <tchu@ucsd.edu>
# @author hweng@ucsd.edu
#---

require 'net/ldap'

class User < ActiveRecord::Base
  def self.find_or_create_for_developer(_access_token)
    u = User.find_by(uid: 1, provider: 'developer') || User.create(uid: 1, provider: 'developer', email: 'developer@ucsd.edu', name: 'developer')
  end

  def self.find_or_create_for_shibboleth(access_token)
    begin
      uid = access_token.uid
      email = access_token['info']['email'] || "#{uid}@ucsd.edu"
      provider = access_token.provider
      name = access_token['info']['name']

    rescue Exception => e
      logger.warn "shibboleth: #{e}"
    end

    u = User.find_by(uid: uid, provider: provider) || User.create(uid: uid, provider: provider, email: email, name: name) unless uid.nil?
  end

  def self.in_group?(uid)
    lookup_group(uid) == uid ? true : false
  end

  def self.lookup_group(search_param)
    result = ''

    ldap = Net::LDAP.new host: Rails.application.secrets.ldap_host,
                         port: Rails.application.secrets.ldap_port,
                         encryption: :simple_tls,
                         base: Rails.application.secrets.ldap_base,
                         auth: {
                           method: :simple,
                           username: Rails.application.secrets.ldap_username,
                           password: Rails.application.secrets.ldap_password
                         }

    result_attrs = ['sAMAccountName']

    ldap.search(filter: ldap_filter(search_param), attributes: result_attrs, return_result: false) do |item|
      result = item.sAMAccountName.first
    end

    get_ldap_response(ldap)

    result
  end

  def self.get_ldap_response(ldap)
    msg = "Response Code: #{ldap.get_operation_result.code}, Message: #{ldap.get_operation_result.message}"

    fail msg unless ldap.get_operation_result.code == 0
  end

  def self.ldap_filter(search_param)
    search_filter = Net::LDAP::Filter.eq('sAMAccountName', search_param)
    category_filter = Net::LDAP::Filter.eq('objectcategory', 'user')
    member_filter = Net::LDAP::Filter.eq('memberof', Rails.application.secrets.ldap_group)
    s_c_filter = Net::LDAP::Filter.join(search_filter, category_filter)
    Net::LDAP::Filter.join(s_c_filter, member_filter)
  end
end
