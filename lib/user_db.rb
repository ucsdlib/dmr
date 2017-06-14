require 'active_record'
#
# User DB
#
class UserDb < ActiveRecord::Base
  establish_connection :ares
end
