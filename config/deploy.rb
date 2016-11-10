# config valid only for current version of Capistrano
lock '3.4.1'
set :application, 'hitch'
set :repo_url, 'git@github.com:sdsunjay/hitch_a_ride.git'

set :user, 'deploy'
#set :deploy_to, "/home/#{ user }/#{ application }"
set :use_sudo, true
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :rbenv_ruby_version, '2.2.4'
set :rbenv_path, '/home/deploy/.rbenv'
set :deploy_to, '/home/deploy/hitch_a_ride'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

set :ssh_options, { :forward_agent => true}
set :rails_env, "production"
# this is ONLY if you are deploying from your server
set :deploy_via, :gitcopy

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
#set :pty, true


set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
#set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# config/deploy.rb
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.4'

# in case you want to set ruby version from the file:
# set :rbenv_ruby, File.read('.ruby-version').strip
#/home/deploy/.rbenv/shims/ruby;
set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH" }
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')


SSHKit.config.command_map[:rake]  = "bundle exec rake" #8
SSHKit.config.command_map[:rails] = "bundle exec rails"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5
#namespace :deploy do
#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
#      within release_path do
#         execute :rake, 'cache:clear'
#      end
#    end
#  end
#end
#namespace :assets do
#    before :backup_manifest, 'deploy:assets:create_manifest_json'
#    task :create_manifest_json do
#      on roles :web do
#        within release_path do
#          execute :mkdir, release_path.join('assets_manifest_backup')
#        end
#      end
#    end
#  end


#default_run_options[:pty] = true

#role :web, "104.131.135.178"                          # Your HTTP server, Apache/etc
#role :app, "104.131.135.178"                          # This may be the same as your `Web` server

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts


#desc "Restart Passenger app"
#task :restart do
#    run "#{ try_sudo } touch #{ File.join(current_path, 'tmp', 'restart.txt') }"
#end

#namespace :deploy do
#  desc "Restarting mod_rails with restart.txt"
#  task :restart, :roles => :app, :except => { :no_release => true } do
#    run "touch #{current_path}/tmp/restart.txt"
#  end
#end
# Capistrano 3.x and Rails 4.x
#namespace :deploy do
#  after :restart, :restart_passenger do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
#      within release_path do
#        execute :touch, 'tmp/restart.txt'
#      end
#    end
#  end
#  after :finishing, 'deploy:restart_passenger'
#end

# If you are using Passenger mod_rails uncomment this:
#namespace :deploy do
  #desc "Human readable description of task" 
  #task :start do ; end
  #task :stop do ; end
 #task :restart, :roles => :app, :except => { :no_release => true } do
  # run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
 #end
#end

namespace :deploy do

  desc "Hitch_A_Ride::Stop"
  task :stop do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute "script/hitch_ride.rb", "stop"
        end
      end
    end
  end

  on roles :all do
    within fetch(:latest_release_directory) do
      with rails_env: fetch(:rails_env) do
        execute :rake, 'assets:precompile'
      end
    end
  end


  #after :restart, :clear_cache do
  after :restart, :restart_passenger do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
         execute :touch, 'tmp/restart.txt'
         #execute :rake, 'cache:clear'
      end
    end
  end
  after :finishing, 'deploy:restart_passenger'
end
