# encoding: utf-8
set :stage, :staging
set :branch, (ENV['BRANCH'] || fetch(:branch, 'master'))
server 'lib-hydrahead-staging.ucsd.edu', user: 'conan', roles: %w{web app db sitemap_noping}
set :rails_env, 'staging'
if ENV['CAP_SSHKEY_STAGING']
  puts "Using key: #{File.join(ENV["HOME"], ENV["CAP_SSHKEY_STAGING"])}"
  set :ssh_options, { keys: File.join(ENV['HOME'], ENV['CAP_SSHKEY_STAGING']) }
end
