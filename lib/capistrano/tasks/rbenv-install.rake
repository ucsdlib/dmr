# Taken from: https://github.com/capistrano/rbenv/issues/83
# This allows us to keep rbenv up to date on the deployment server
namespace :rbenv do
  desc 'Install rbenv'
  task :install do
    on roles(:web) do
      begin
        execute "git clone https://github.com/rbenv/rbenv.git #{fetch(:rbenv_path)}"
      rescue SSHKit::Command::Failed
        puts 'rbenv already installed, updating...'
        execute "cd #{fetch(:rbenv_path)} && git pull"
      end
      execute "mkdir -p #{fetch(:rbenv_path)}/plugins"
      begin
        execute "git clone https://github.com/rbenv/ruby-build.git #{fetch(:rbenv_path)}/plugins/ruby-build"
      rescue SSHKit::Command::Failed
        puts 'rbenv/ruby-build plugin already installed, updating...'
        execute "cd #{fetch(:rbenv_path)}/plugins/ruby-build && git pull"
      end
      rbenv_ruby = File.read('.ruby-version').strip
      execute "#{fetch(:rbenv_path)}/bin/rbenv install -s #{fetch(:rbenv_ruby)||rbenv_ruby}"
      execute "#{fetch(:rbenv_path)}/bin/rbenv global #{fetch(:rbenv_ruby)||rbenv_ruby}"
      execute "#{fetch(:rbenv_path)}/shims/gem install bundler --no-document"
      if fetch(:rbenv_ruby).nil?
        puts "\nPlease uncomment the line `# set :rbenv_ruby, File.read('.ruby-version').strip` to enable capistrano rbenv"
      end
    end
  end
end
