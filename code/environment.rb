RAILS_ROOT = File.dirname(__FILE__) + "/../"
RAILS_ENV  = ENV['RAILS_ENV'] || 'production'


# Mocks first.
ADDITIONAL_LOAD_PATHS = ["#{RAILS_ROOT}/test/mocks/#{RAILS_ENV}"]

# Then model subdirectories.
ADDITIONAL_LOAD_PATHS.concat(Dir["#{RAILS_ROOT}/app/models/[_a-z]*"])
ADDITIONAL_LOAD_PATHS.concat(Dir["#{RAILS_ROOT}/components/[_a-z]*"])

# Followed by the standard includes.
ADDITIONAL_LOAD_PATHS.concat %w(
  app 
  app/models 
  app/controllers 
  app/helpers 
  app/apis 
  components 
  config 
  lib 
  vendor 
  vendor/rubypants
  vendor/redcloth/lib
  vendor/bluecloth/lib
  vendor/flickr
  vendor/syntax/lib
  vendor/sparklines/lib
  vendor/uuidtools/lib
  vendor/rails/railties
  vendor/rails/railties/lib
  vendor/rails/actionpack/lib
  vendor/rails/activesupport/lib
  vendor/rails/activerecord/lib
  vendor/rails/actionmailer/lib
  vendor/rails/actionwebservice/lib
).map { |dir| "#{RAILS_ROOT}/#{dir}" }.select { |dir| File.directory?(dir) }

# Prepend to $LOAD_PATH
ADDITIONAL_LOAD_PATHS.reverse.each { |dir| $:.unshift(dir) if File.directory?(dir) }

# Load included libraries.
require 'redcloth' 
require 'bluecloth' 
require 'rubypants' 
require 'flickr'
require 'uuidtools'

# Require Rails libraries.
require 'rubygems' unless File.directory?("#{RAILS_ROOT}/vendor/rails")

# force Rails 0.13.1
#require_gem 'activesupport',     '= 1.1.1'
#require_gem 'activerecord',      '= 1.11.1'
#require_gem 'actionpack',  '= 1.9.1'
#require_gem 'actionmailer',      '= 1.0.1'
#require_gem 'actionwebservice', '= 0.8.1'

require 'active_support'
require 'active_record'
require 'action_controller'
require 'action_mailer'
require 'action_web_service'

# Environment-specific configuration.
require_dependency 'migrator'
require_dependency 'renderfix'
require_dependency 'rails_patch/components'
require_dependency 'theme'
require_dependency 'login_system'
require_dependency "environments/#{RAILS_ENV}"
ActiveRecord::Base.configurations = File.open("#{RAILS_ROOT}/config/database.yml") { |f| YAML::load(f) }
ActiveRecord::Base.establish_connection


# Configure defaults if the included environment did not.
begin
  RAILS_DEFAULT_LOGGER = Logger.new("#{RAILS_ROOT}/log/#{RAILS_ENV}.log")
  RAILS_DEFAULT_LOGGER.level = (RAILS_ENV == 'production' ? Logger::INFO : Logger::DEBUG)
rescue StandardError
  RAILS_DEFAULT_LOGGER = Logger.new(STDERR)
  RAILS_DEFAULT_LOGGER.level = Logger::WARN
  RAILS_DEFAULT_LOGGER.warn(
    "Rails Error: Unable to access log file. Please ensure that log/#{RAILS_ENV}.log exists and is chmod 0666. " +
    "The log level has been raised to WARN and the output directed to STDERR until the problem is fixed."
  )
end

[ActiveRecord, ActionController, ActionMailer].each { |mod| mod::Base.logger ||= RAILS_DEFAULT_LOGGER }
[ActionController, ActionMailer].each { |mod| mod::Base.template_root ||= "#{RAILS_ROOT}/app/views/" }
ActionController::Routing::Routes.reload

Controllers = Dependencies::LoadingModule.root(
  File.join(RAILS_ROOT, 'app', 'controllers'),
  File.join(RAILS_ROOT, 'components')
)

# Include your app's configuration here:
$KCODE = 'u'
require_dependency 'jcode'
require_dependency 'aggregations/audioscrobbler'
require_dependency 'aggregations/delicious'
require_dependency 'aggregations/tada'
require_dependency 'aggregations/flickr'
require_dependency 'aggregations/fortythree'
require_dependency 'aggregations/upcoming'
require_dependency 'config_manager' 
require_dependency 'configuration'
require_dependency 'spam_protection'
require_dependency 'xmlrpc_fix'
require_dependency 'guid'

ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS.update(:database_manager => CGI::Session::ActiveRecordStore)      
ActionController::Base.fragment_cache_store = ActionController::Caching::Fragments::FileStore.new("#{RAILS_ROOT}/cache/fragment/")

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :long_weekday => '%a %B %e, %Y %H:%M'
)

ActionController::Base.enable_upload_progress