<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
    <link rel="shortcut icon" type="image/x-icon" href="/favicon.ico" />
    <link rel="alternate" type="application/atom+xml" title="rbJL.net" href="http://rbJL.net/atom" />
    <title>J-_-L  | snippets | 24 | rails3-upgrade-the-cookie-session-secret.rb</title>
  </head>

  <body>
    <pre># # # # # # # # #
# /24/rails3-upgrade-the-cookie-session-secret.rb
#
# by               Jan Lelis
# e-mail:          mail@janlelis.de
# type/version:    ruby 
# snippet url:     http://ruby.janlelis.de/24/rails3-upgrade-the-cookie-session-secret.rb
# original post:   http://ruby.janlelis.de/24-upgrading-to-rails-3-obstacles-and-helper-scripts
# license:         CC-BY (DE)
#
# (c) 2010 Jan Lelis.

#!/usr/bin/env ruby

# Upgrades the session store. Only run this script, if you use cookies for
#  session storage. 
#
# This script is quite destructive and uses eval, so please check if 
#  your config/initializers/session_store.rb file looks like this:
#
# ActionController::Base.session = {
#   :key     =&gt; ‘_app_session’,
#   :secret  =&gt; ‘secret’
# }
#
# Please upgrade manually, if you have changed more than the values

SESSION_PATH = &#39;config/initializers/session_store.rb&#39;
SECRET_PATH  = &#39;config/initializers/cookie_verification_secret.rb&#39;

if !File.exist? SESSION_PATH
  raise &#39;Please call the script from the Rails root directory&#39;
else
  # get data
  old = File.read SESSION_PATH

  if matched = old =~ /ActionController::Base.session\s+=/
    old[/ActionController::Base.session\s+=/] = &#39;&#39;
    user_data = eval old
  end

  if !matched || !user_data.is_a?(Hash)
    raise &quot;#{SESSION_PATH} has changed too much, aborting...&quot;
  end

  # write new files
  File.open(SECRET_PATH,&#39;w&#39;){|file|
    file.puts &quot;Rails.application.config.secret_token = &#39;#{user_data[:secret]}&#39;&quot;
  }

  File.open(SESSION_PATH,&#39;w&#39;){|file|
    file.puts &quot;Rails.application.config.session_store :cookie_store, :key =&gt; &#39;#{user_data[:key]}&#39;&quot;
  } if File.exists? SECRET_PATH

  puts :Done
end</pre>
  </body>
</html>
