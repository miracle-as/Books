set :customer, "Lenio"
set :application, "books"

# SCM
set :repository,  "git://git.lenio.dk/#{customer}/#{application}"
set :scm, :git
set :branch, "master"
set :deploy_via, :copy
set :git_shallow_clone, 1

set :user, "sysadm"
server "#{application}.lenio.dk", :web, :app, :db, :primary => true

set :deploy_to, "/var/www/apps/#{application}"

# Misc variables
set :use_sudo, false

namespace :books do
  namespace :db do
    desc "Make symlink for database yaml and production database" 
    task :symlink do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
      run "ln -nfs #{shared_path}/config/amazon.yml #{release_path}/config/amazon.yml" 
      run "ln -nfs #{shared_path}/config/saxo.yml #{release_path}/config/saxo.yml" 
    end
    after "deploy:update_code", "books:db:symlink"
  end

  desc "Run tests"
  task :run_tests do
    run "cd #{release_path} && rake db:create"
    run "cd #{release_path} && rake db:migrate"
    run "cd #{release_path} && rake"
  end
  before 'deploy:symlink', 'books:run_tests'
end


namespace :deploy do
 task :restart, :roles => :app do
   send(:run, "touch #{current_path}/tmp/restart.txt")
 end

 task :start, :roles => :app do
   send(run_method, "/etc/init.d/apache2 restart")
 end
end
