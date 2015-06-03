source 'https://rubygems.org'

gem 'rails', '4.2.1'
gem 'sqlite3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem "bootstrap-sass", '~> 2.3.0'

# Deploy with Capistrano
gem 'capistrano', '~> 3.3.3'
gem 'capistrano-rails', '~> 1.1.2'
gem 'capistrano-rbenv', '~> 2.0.2'
gem 'capistrano-bundler', '~> 1.1.3'

group :development, :test do
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'capybara', '~> 2.4.4'
  gem 'launchy', '~> 2.4.3'                           
  gem 'rspec-rails', '~> 2.14.2' # 2.99+ breaks rspec_junit_formatter
  gem 'unicorn', '~> 4.8.3'  
end

group :staging do
  gem 'activerecord-postgresql-adapter'
  gem 'rake', '~> 10.4.0'
end