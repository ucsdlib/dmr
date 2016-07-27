#
# @author Vivian <tchu@ucsd.edu>
#
require 'base64'
require 'pathname'

APP_ROOT = Pathname.new File.expand_path('../../../', __FILE__)
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
    return unless filename
    encrypted = encrypt_stream_name(objid, filename, request.ip)
    "#{Rails.configuration.wowza_baseurl}#{encrypted}"
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
    nonce = create_nonce

    # load key from file
    key = ENV.fetch('APPS_DMR_STREAMING_KEY')
    # encrypt
    str = "#{pid} #{fid} #{ip}"
    cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    cipher.encrypt
    cipher.key = key
    cipher.iv = nonce
    enc = cipher.update(str) + cipher.final

    "#{nonce},#{base64_encode(enc)}"
  end

  ##
  # Encode base64
  #
  # @param enc [String] the encrypted string
  #
  # @return [String] base64-encode
  ##

  def base64_encode(enc)
    # base64-encode
    b64 = Base64.encode64 enc
    b64.tr('+', '-').tr('/', '_').delete("\n")
  end

  ##
  # Creates random nonce
  #
  #
  # @return [String] nonce
  ##
  def create_nonce
    nonce = rand(36**16).to_s(36)
    nonce += 'x' while nonce.length < 16
    nonce
  end
end
