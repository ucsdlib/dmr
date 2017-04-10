#
# @author Vivian <tchu@ucsd.edu>
#
require 'net/http'
#
# This module supports the function in Audio controller
#
module AudiosHelper
  def url_exist?(url_string)
    url_string = url_string.delete(' ') if url_string
    url = URI.parse(url_string)
    req = Net::HTTP.new(url.host, url.port)
    req.use_ssl = (url.scheme == 'https')
    path = url.path if url.path.present?
    res = req.request_head(path || '/')
    res.code != '404' # false if returns 404 - not found
  rescue Errno::ENOENT
    false
  end
end
