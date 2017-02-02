require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.every '1440m' do
  current_date = DateTime.current.strftime('%Y-%m-%d')
  q = "end_date != '' AND course NOT LIKE '%ARCHIVE%'"
  results = Course.where(q)
  Rails.logger.info "AutoArchive Date:#{DateTime.current} - size:#{results.size}"
  results.each do |c|
    tmp_date = DateTime.strptime(c.end_date, '%m/%d/%Y')   
    if tmp_date.to_date.to_s < current_date
      c.course = "#{c.course} - ARCHIVE #{c.updated_at}"
      c.save!
      Rails.logger.info "AutoArchive  #{DateTime.current} - course id - #{c.id} - end date #{c.end_date} - title #{c.course}"
    end
  end
  Rails.logger.flush
end