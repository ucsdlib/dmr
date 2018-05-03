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
    if filename.include?('.mp4')
      "#{Rails.configuration.wowza_baseurl}#{encrypted}"
    else
      "#{Rails.configuration.wowza_audio_baseurl}#{encrypted}"
    end
  end

  def grab_secure_token_url(filename, base_url)
    return unless filename
    token_end_time = wowza_token_end_time
    token_hash = wowza_token_hash(token_end_time, filename, base_url)
    "#{Rails.configuration.secure_token_name}endtime=#{token_end_time}&#{Rails.configuration.secure_token_name}hash=#{token_hash}".html_safe
  end

  def wowza_token_hash(end_time, filename, base_url)
    token_params = []
    token_params << Rails.configuration.secure_token_secret
    token_params << "#{Rails.configuration.secure_token_name}endtime=#{end_time}"
    token_params = token_params.sort
    stream = base_url.sub(%r{.*?\/}, '')
    hash_in = "#{stream}#{filename}?#{token_params.join('&')}"
    hash_out = Digest::SHA2.new(256).digest(hash_in.to_s)
    base64_encode(hash_out).gsub('+/', '-_').to_s
  end

  def wowza_token_end_time
    Time.zone = 'America/Los_Angeles'
    Time.now.to_i + 48.hours
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
