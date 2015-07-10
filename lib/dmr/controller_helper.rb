module Dmr
  module ControllerHelper 
    ##
    # Displays a file given a fileid
    #
    # @note The output of this method should be assigned to the response_body of a controller
    # the bytes returned from the datastream dissemination will be written to the response
    # piecemeal rather than being loaded into memory as a String 
    #
    # @param objid [String] the object id
    # @param fileid [String] the file id
    #
    # @return [Bytes] the file content
    #
    def display_file(objid, fileid)
      start = Time.now.to_f
      
      if(fileid.include? ".jpg")
        # set headers
        disposition = params[:disposition] || 'inline'
        filename = params["filename"] || "#{objid}#{fileid}"
        headers['Content-Disposition'] = "#{disposition}; filename=#{filename}"
   
        headers['Content-Type'] = 'image/jpeg'
    
        headers['Last-Modified'] = Time.now.ctime.to_s
      
        self.response_body = Enumerator.new do |blk|
          File.open("#{Rails.configuration.file_path}#{fileid}", "rb") do |seg|
            blk << seg.read
          end
        end

        dur = (Time.now.to_f - start) * 1000
        logger.info sprintf("Served file #{filename} in %0.1fms", dur)
      else
        headers['Content-Type'] = 'text/html'   
        headers['Last-Modified'] = Time.now.ctime.to_s      
        self.response_body = "#{fileid} is not found"
      end
    end
  end
end
