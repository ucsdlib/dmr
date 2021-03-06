# encoding: utf-8
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = {host: 'pontos.ucsd.edu'}
  
  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Do not compress assets
  config.assets.compress = false
  
  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  config.wowza_baseurl = 'lib-streaming.ucsd.edu/dmr-basic/_definst_/mp4:MP4_Archive/'
  config.wowza_audio_baseurl = 'lib-streaming.ucsd.edu/dmr-basic/_definst_/mp3:MP3_Archive/'
  config.secure_token_audio_baseurl = 'lib-streaming.ucsd.edu/dmr-securetoken/_definst_/mp3:MP3_Archive/'
  config.secure_token_video_baseurl = 'lib-streaming.ucsd.edu/dmr-securetoken/_definst_/mp4:MP4_Archive/'
  config.secure_token_name = ENV.fetch('APPS_DMR_SECURE_TOKEN_NAME') {'default'}
  config.secure_token_secret = ENV.fetch('APPS_DMR_SECURE_TOKEN_SECRET') {'default'}
  config.shibboleth = true
  config.receiver_emails = ''
  config.splunk_host = 'librarytest'
  config.rails_host = 'lib-hydrahead-staging'     
end            
