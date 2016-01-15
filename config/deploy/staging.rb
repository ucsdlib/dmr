# encoding: utf-8
set :stage, :staging
set :branch, 'staging'
server 'lib-hydrahead-staging.ucsd.edu', user: 'conan', roles: %w{web app db sitemap_noping}
set :rails_env, 'staging'
if ENV['CAP_SSHKEY_STAGING']
  puts "Using key: #{File.join(ENV["HOME"], ENV["CAP_SSHKEY_STAGING"])}"
  set :ssh_options, { keys: File.join(ENV['HOME'], ENV['CAP_SSHKEY_STAGING']) }
else
  set :ssh_options, keys: ["config/deploy_id_rsa"] if File.exist?("config/deploy_id_rsa")
end
