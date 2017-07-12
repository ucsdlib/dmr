# bundle exec rake changeurl
desc 'ChangeUrl media object'
task :changeurl, [:filename] => :environment do
  current_date = DateTime.current.strftime('%Y-%m-%d')
  q = "end_date != '' AND end_date NOT LIKE '%EXPIRED%'"
  update_url(Media, q, current_date)
  update_url(Audio, q, current_date)
end

def update_url(object_type, query, current_date)
  results = object_type.where(query)
  results.each do |c|
    tmp_date = DateTime.strptime(c.end_date, '%Y-%m-%d')
    next unless tmp_date.to_date.to_s < current_date
    c.end_date = "#{c.end_date} - EXPIRED #{c.updated_at}"
    c.save!
    Rails.logger.info "ChangeUrl  #{DateTime.current} - id - #{c.id} - endDate #{c.end_date}"
  end
  Rails.logger.flush
end
