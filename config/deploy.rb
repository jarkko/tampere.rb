set :application, "tampere.rb"
set :repository,  "file:///var/lib/svn/tampere.rb/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "majakari.net"
role :web, "majakari.net"
role :db,  "majakari.net", :primary => true