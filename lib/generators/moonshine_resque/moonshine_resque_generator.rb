class MoonshineResqueGenerator < Rails::Generators::Base
  desc <<-INTRO

To monitor Resque with God, generate the configuration file 
and install moonshine_god.

  script/rails g moonshine_resque --with-god=true

INTRO

  class_option :with_god, :default => false, :type => :boolean

  def self.source_root
    @_moonshine_resque_source_root ||= Pathname.new(__FILE__).dirname.join('..', '..', '..', 'generators', 'moonshine_resque', 'templates')
  end

  def manifest
    plugin("moonshine_redis", :git => "git://github.com/railsmachine/moonshine_redis.git")
    template "resque.yml", "config/resque.yml"
    template "resque.rb", "config/initializers/resque.rb"
    
    gem("resque")
    gem("redis")

    if options[:with_god]
      plugin("moonshine_god", :git => "git://github.com/railsmachine/moonshine_god.git")
      template "resque.god", "config/god/resque.god"
    end
  end
end
