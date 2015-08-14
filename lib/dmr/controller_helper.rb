#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'open-uri'

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
          open("#{Rails.configuration.file_path}#{fileid}", "rb") do |seg|
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
    
    ##
    # Adds media objects to current course list
    #
    # @param filename [Array] set of Media's ids
    # @param current_course [String] Current Course ID
    #
    ##

    def add_media_to_course(med_ids,current_course)
      media_ids = med_ids.collect {|id| id.to_i} if med_ids
      @course = Course.find_by_id(current_course.to_i) if current_course
      current_course_media_ids = @course.media.map(&:id) if @course.media
      if media_ids && @course
        media_ids.each do |id|
          med = Media.find_by_id(id)
          @course.reports.create(media: med) if med && !current_course_media_ids.include?(id)
        end
      end    
    end    
  end
end
