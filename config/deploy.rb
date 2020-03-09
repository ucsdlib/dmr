# encoding: utf-8
set :application, 'dmr'
set :repo_url, 'git@github.com:ucsdlib/dmr.git'

set :deploy_to, '/pub/dmr'
set :scm, :git

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

#set :linked_files, %w{config/secrets.yml config/database.yml config/.coveralls.yml config/streaming.key}
#set :linked_dirs, %w{config/environments}

namespace :deploy do

  namespace :assets do
    desc 'Pre-compile assets'
    task :precompile do
      on roles(:web) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'RAILS_RELATIVE_URL_ROOT=/dmr assets:precompile'
          end
        end
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :mkdir, "-p #{release_path.join('tmp')}"
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Write the current version to public/version.txt'
  task :write_version do
    on roles(:app), in: :sequence do
      within repo_path do
        execute :echo, "`git describe --all --always --long --abbrev=40 HEAD` `date +\"%Y-%m-%d %H:%M:%S %Z\"` #{ENV['CODENAME']} > #{release_path}/public/version.txt"
      end
    end
  end

  after :finishing, 'deploy:write_version'
  after :finishing, 'deploy:assets:precompile'
  after :finishing, 'deploy:cleanup'
  after :finishing, 'deploy:restart'

end

# WIP: get rbenv to install before validation
Capistrano::DSL.stages.each do |stage|
  before stage, 'rbenv:install'
end

# Invoke rbenv install before validation
# before "rbenv:validate", "rbenv:install"
