# encoding: utf-8
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true
  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files = false

  # Compress JavaScripts and CSS.
  # config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

   # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for apache

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  #config.assets.precompile += ['','']

   # action mailer 
  #config.action_mailer.delivery_method = :sendmail
  # Defaults to:
  # config.action_mailer.sendmail_settings = {
  #   location: '/usr/sbin/sendmail',
  #   arguments: '-i -t'
  # }
  
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = {host: 'librarytest.ucsd.edu'}
  
  #config.action_mailer.default_options = {from: 'xxx@ucsd.edu'}

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Set to :debug to see everything in the log.
  config.log_level = :info
  config.log_formatter = ::Logger::Formatter.new

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  config.wowza_baseurl = 'lib-streaming.ucsd.edu:1936/dmr-basic/_definst_/mp4:MP4_Archive/'
  config.wowza_audio_baseurl = 'lib-streaming.ucsd.edu:1936/dmr-basic/_definst_/mp3:MP3_Archive/'
  config.secure_token_audio_baseurl = 'lib-streaming.ucsd.edu:1936/dmr-securetoken/_definst_/mp3:MP3_Archive/'
  config.secure_token_video_baseurl = 'lib-streaming.ucsd.edu:1936/dmr-securetoken/_definst_/mp4:MP4_Archive/'
  config.secure_token_name = ENV.fetch('APPS_DMR_SECURE_TOKEN_NAME') {'default'}
  config.secure_token_secret = ENV.fetch('APPS_DMR_SECURE_TOKEN_SECRET') {'default'}
  config.shibboleth = true
  config.receiver_emails = ''
  config.splunk_host = 'librarytest'
  config.rails_host = 'lib-hydrahead-staging' 
end
