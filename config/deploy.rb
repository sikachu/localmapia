set :application, "localmapia.com"
set :repository,  "git@github.com:sikachu/localmapia.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :deploy_via, :remote_cache
set :use_sudo, false

role :app, "localmapia.com"
role :web, "localmapia.com"
role :db,  "localmapia.com", :primary => true
ssh_options[:port] = 622
ssh_options[:forward_agent] = true
set :branch, "master"
set :git_enable_submodules, 1

namespace :deploy do
  %w(start stop restart).each do |action| 
     desc "#{action} the Thin processes"  
     task action.to_sym do
       find_and_execute_task("thin:#{action}")
    end
  end 
end

namespace :thin do  
  %w(start stop restart).each do |action| 
  desc "#{action} the app's Thin Cluster"  
    task action.to_sym, :roles => :app do  
      run "thin #{action} -c #{deploy_to}/current -C /etc/thin/localmapia.yml" 
    end
  end
end

after "deploy:update_code" do
  run "rm #{release_path}/config/database.yml && ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end