# encoding: utf-8
#
# @author Vivian <tchu@ucsd.edu>
#
require 'open-uri'
#
# Supports the file related function
#
module Dmr
  #
  # Supports the file related function
  #
  module FileControllerHelper
    ##
    # Displays a file given a fileid
    #
    # @note The output of this method should be assigned to the
    # response_body of a controller the bytes returned from the datastream
    # dissemination will be written to the response piecemeal rather
    # than being loaded into memory as a String
    #
    # @param objid [String] the object id
    # @param fileid [String] the file id
    #
    # @return [Bytes] the file content
    #
    def display_file(objid, fileid)
      return unless fileid.include? '.jpg'
      set_file_header(objid, fileid)

      self.response_body = Enumerator.new do |blk|
        open("#{Rails.configuration.file_path}#{fileid}", 'rb') do |seg|
          blk << seg.read
        end
      end
    end

    ##
    # Sets header
    #
    # @param objid [String] the object id
    # @param fileid [String] the file id
    #
    #
    def set_file_header(objid, fileid)
      disposition = params[:disposition] || 'inline'
      filename = params['filename'] || "#{objid}#{fileid}"
      headers['Content-Disposition'] = "#{disposition}; filename=#{filename}"
      headers['Content-Type'] = 'image/jpeg'
      headers['Last-Modified'] = Time.zone.now.ctime.to_s
    end
  end
end
