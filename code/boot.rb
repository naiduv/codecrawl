<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <title>View Source: ./config/boot.rb</title>
  <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
  <link href="/stylesheets/source.css?1283582944" media="screen" rel="stylesheet" type="text/css" />
  <link href="/stylesheets/sh_style.css?1407647649" media="screen" rel="stylesheet" type="text/css" />
  <script src="/javascripts/sh_main.min.js?1283582895" type="text/javascript"></script>
  <script src="/javascripts/lang/sh_rb.min.js?1283582877" type="text/javascript"></script>
</head>
<body onload="sh_highlightDocument();">
  <pre class="sh_rb"># Don&#39;t change this file!
# Configure your app in config/environment.rb and config/environments/*.rb

RAILS_ROOT = &quot;#{File.dirname(__FILE__)}/..&quot; unless defined?(RAILS_ROOT)

module Rails
  class &lt;&lt; self
    def boot!
      unless booted?
        preinitialize
        pick_boot.run
      end
    end

    def booted?
      defined? Rails::Initializer
    end

    def pick_boot
      (vendor_rails? ? VendorBoot : GemBoot).new
    end

    def vendor_rails?
      File.exist?(&quot;#{RAILS_ROOT}/vendor/rails&quot;)
    end

    def preinitialize
      load(preinitializer_path) if File.exist?(preinitializer_path)
    end

    def preinitializer_path
      &quot;#{RAILS_ROOT}/config/preinitializer.rb&quot;
    end
  end

  class Boot
    def run
      load_initializer
      Rails::Initializer.run(:set_load_path)
    end
  end

  class VendorBoot &lt; Boot
    def load_initializer
      require &quot;#{RAILS_ROOT}/vendor/rails/railties/lib/initializer&quot;
      Rails::Initializer.run(:install_gem_spec_stubs)
      Rails::GemDependency.add_frozen_gem_path
    end
  end

  class GemBoot &lt; Boot
    def load_initializer
      self.class.load_rubygems
      load_rails_gem
      require &#39;initializer&#39;
    end

    def load_rails_gem
      if version = self.class.gem_version
        gem &#39;rails&#39;, version
      else
        gem &#39;rails&#39;
      end
    rescue Gem::LoadError =&gt; load_error
      $stderr.puts %(Missing the Rails #{version} gem. Please `gem install -v=#{version} rails`, update your RAILS_GEM_VERSION setting in config/environment.rb for the Rails version you do have installed, or comment out RAILS_GEM_VERSION to use the latest version installed.)
      exit 1
    end

    class &lt;&lt; self
      def rubygems_version
        Gem::RubyGemsVersion rescue nil
      end

      def gem_version
        if defined? RAILS_GEM_VERSION
          RAILS_GEM_VERSION
        elsif ENV.include?(&#39;RAILS_GEM_VERSION&#39;)
          ENV[&#39;RAILS_GEM_VERSION&#39;]
        else
          parse_gem_version(read_environment_rb)
        end
      end

      def load_rubygems
        min_version = &#39;1.3.2&#39;
        require &#39;rubygems&#39;
        unless rubygems_version &gt;= min_version
          $stderr.puts %Q(Rails requires RubyGems &gt;= #{min_version} (you have #{rubygems_version}). Please `gem update --system` and try again.)
          exit 1
        end

      rescue LoadError
        $stderr.puts %Q(Rails requires RubyGems &gt;= #{min_version}. Please install RubyGems and try again: http://rubygems.rubyforge.org)
        exit 1
      end

      def parse_gem_version(text)
        $1 if text =~ /^[^#]*RAILS_GEM_VERSION\s*=\s*[&quot;&#39;]([!~&lt;&gt;=]*\s*[\d.]+)[&quot;&#39;]/
      end

      private
        def read_environment_rb
          File.read(&quot;#{RAILS_ROOT}/config/environment.rb&quot;)
        end
    end
  end
end

if defined? JRUBY_VERSION
  require &quot;rails_appengine/active_support_vendored&quot;
  require &quot;rails_appengine/bundler_boot&quot; 
end

# All that for this:
Rails.boot!
</pre>
</body>
</html>
