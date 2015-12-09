# encoding: utf-8
set :stage, :pontos
set :branch, 'develop'
server 'pontos.ucsd.edu', user: 'conan', roles: %w{app db}
set :rails_env, 'pontos'
set :ssh_options, keys: ["config/deploy_id_rsa"] if File.exist?("config/deploy_id_rsa")
