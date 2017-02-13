# bundle exec rake autoarchive
desc 'Autoarchive course list'
task :autoarchive, [:filename] => :environment do
  current_date = DateTime.current.strftime('%Y-%m-%d')
  q = "end_date != '' AND course NOT LIKE '%ARCHIVE%'"
  results = Course.where(q)
  Rails.logger.info "AutoArchive Date:#{DateTime.current} - size:#{results.size}"
  results.each do |c|
    tmp_date = DateTime.strptime(c.end_date, '%m/%d/%Y')
    next unless tmp_date.to_date.to_s < current_date
    c.course = "#{c.course} - ARCHIVE #{c.updated_at}"
    c.save!
    Rails.logger.info "AutoArchive  #{DateTime.current} - id - #{c.id} - endDate #{c.end_date}"
  end
  Rails.logger.flush
end
