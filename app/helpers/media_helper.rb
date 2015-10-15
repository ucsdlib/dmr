# encoding: utf-8
#
# @author Vivian <tchu@ucsd.edu>
#
require 'base64'
#
# This module supports the function in Media controller
#
module MediaHelper
  ##
  # Builds Wowza URL
  #
  # @param filename [String] the file name
  # @param objid [String] Object ID
  #
  # @return [String] url or nil
  ##

  def grab_wowza_url(filename, objid)
    unless filename.nil?
      encrypted = encrypt_stream_name(objid, filename, request.ip)
      return Rails.configuration.wowza_baseurl + encrypted
    end
  end

  ##
  # Video stream name encryption
  #
  # @param pid [String] the Object Id
  # @param fid [String] the File Id
  # @param ip [String] the User IP address
  #
  # @return [String] url or nil
  # @author David T.
  ##

  def encrypt_stream_name(pid, fid, ip)
    # random nonce
    nonce = rand(36**16).to_s(36)
    nonce += 'x' while nonce.length < 16

    # load key from file
    key = File.read Rails.configuration.wowza_directory + 'streaming.key'

    # encrypt
    str = "#{pid} #{fid} #{ip}"
    cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    cipher.encrypt
    cipher.key = key
    cipher.iv = nonce
    enc = cipher.update(str) + cipher.final

    # base64-encode
    b64 = Base64.encode64 enc
    b64 = b64.tr('+', '-').tr('/', '_').delete("\n")
    "#{nonce},#{b64}"
  end
end
