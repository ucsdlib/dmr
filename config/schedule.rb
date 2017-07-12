set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every :friday, :at => '10pm'  do
  rake "autoarchive"
  rake "changeurl"
end
