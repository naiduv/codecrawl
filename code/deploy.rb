# Introductory Capistrano config for Dreamhost.
#
# ORIGINAL BY: Jamis Buck
#
# Docs: http://manuals.rubyonrails.com/read/chapter/98
#
# HIGHLY MODIFIED BY: Geoffrey Grosenbach boss@topfunky.com
#
# Docs: http://nubyonrails.com/pages/shovel_dreamhost
#
# ALSO MODIFIED BY: Casper Fabricius me@casperfabricius.com
#
# Docs: http://casperfabricius.com/blog/2006/05/21/rails-on-dreamhost/
#
# ALSO MODIFIED BY: Frederic Bollon email_fb-rails@yahoo.fr
# 
# Docs: http://www.blog.fbollon.net/?p=39
#
# USE AT YOUR OWN RISK! THIS SCRIPT MODIFIES FILES, MAKES DIRECTORIES, AND STARTS
# PROCESSES. FOR ADVANCED OR DARING USERS ONLY!
#
# DESCRIPTION
#
# This is a customized recipe for easily deploying web apps to a shared host.
#
# You also need to modify Apache's document root using Dreamhost's web control panel, and several other things.
#
# For full details, see http://casperfabricius.com/blog/2006/05/21/rails-on-dreamhost/
#
# To setup lighty, first edit this file for your primary Dreamhost account.
#
# Then run:
#     
#
# This will create all the necessary directories for running Capistrano.
#
# From then, you can deploy your application with Capistrano's standard
#   rake deploy
#
# Or rollback with
#   rake rollback
# 
# This defines a deployment "recipe" that you can feed to switchtower
# (http://manuals.rubyonrails.com/read/book/17). It allows you to automate
# (among other things) the deployment of your application.

set :user, 'monUserSSH'
set :application, "mondomaine.com"
set :repository, "http://svn.mondomaine.com/monprojet"
set :svn_username, "monUserSVN"

# =============================================================================
# You shouldn't have to modify the rest of these
# =============================================================================

role :web, application
role :app, application
role :db, application, :primary => true

set :deploy_to, "/home/#{user}/#{application}"
# set :svn, "/path/to/svn" # defaults to searching the PATH
set :use_sudo, false
set :restart_via, :run
set :checkout, "export"
set(:svn_password) { Capistrano::CLI.password_prompt }

task :after_symlink, :roles => [:web, :app] do

# Force production enviroment by replacing a line in environment.rb
run "perl -i -pe \"s/# ENV\\['RAILS_ENV'\\] \\|\\|= 'production'/ENV['RAILS_ENV'] ||= 'production'/\" #{current_path}/config/environment.rb"

# Ensure Rails in the vendor dir is used by replacing a line in fcgi_handler.rb
run "perl -i -pe \"s/require 'dispatcher'/require '#{current_path.gsub(/\//, '\\/')}\\/vendor\\/rails\\/railties\\/lib\\/dispatcher'/\" #{current_path}/vendor/rails/railties/lib/fcgi_handler.rb"

# Make dispatcher executable
run "chmod a+x #{current_path}/public/dispatch.fcgi"

#rename .htaccess.example (production version) in .htaccess
run "cp #{current_path}/public/.htaccess.example.prd #{current_path}/public/.htaccess"

#rename auth_generator.yml.example (production version) in auth_generator.yml
run "cp #{current_path}/config/auth_generator.yml.prd #{current_path}/config/auth_generator.yml"

end

#Create symlinks for shared image upload directories
task :after_update_code do
  %w{recipe}.each do |share|
    run "ln -s #{shared_path}/#{share} #{release_path}/public/#{share}"
  end
end

#desc "Restart the FCGI processes on the app server as a regular user."
task :restart, :roles => :app do
run "ruby #{current_path}/script/process/reaper -a graceful -dispatcher=dispatch.fcgi"
end