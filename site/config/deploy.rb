set :application, "Rails Tutorial"
set :domain, "www.railschina.org"
set :use_sudo, false
set :user, "ruby"
set :repository,  "./_site"
set :scm, :none

 
role :web, domain
role :app, domain
role :db,  domain, :primary => true 

set :deploy_to, "/home/#{user}/www/rails-tutorial"

set :deploy_via, :copy


namespace :local do
  task :generate_website do
    print "generate the lastest guides"
    system "cd site"
    system "jekyll build"
  end
end

namespace :deploy do
  task :migrate do
  end
  task :finalize_update do
  end
  task :start do
  end
  task :stop do 
  end
  task :restart do
  end
end

#callbacks
#after 'deploy:setup', 'remote:create_symlink'
before 'deploy:setup', 'local:generate_website'

