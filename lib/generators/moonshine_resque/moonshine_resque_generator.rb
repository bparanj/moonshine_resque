class MoonshineResqueGenerator < Rails::Generators::Base
  desc <<-INTRO

To monitor Resque with God, generate the configuration file 
and install moonshine_god.

  script/rails g moonshine_resque --with-god

INTRO

  class_option :with_god, :default => false, :type => :boolean

  def self.source_root
    @_moonshine_resque_source_root ||= Pathname.new(__FILE__).dirname.join('..', '..', '..', 'generators', 'moonshine_resque', 'templates')
  end

  def self.god_source_root
    @_moonshine_resque_god_source_root ||= Pathname.new(__FILE__).dirname.join('..', '..', '..', 'generators', 'moonshine_resque_god', 'templates')
  end

  def manifest
    plugin("moonshine_redis", :git => "git://github.com/railsmachine/moonshine_redis.git")
    template "resque.yml", "config/resque.yml"
    
    gem("resque")
    gem("redis")

    rakefile("resque_tasks.rake") do
      "require 'resque/tasks'"
    end

    initializer("resque.rb", File.read(File.join(MoonshineResqueGenerator.source_root, 'resque.rb')))

    if options[:with_god]
      plugin("moonshine_god", :git => "git://github.com/railsmachine/moonshine_god.git")
      template File.join(MoonshineResqueGenerator.god_source_root, 'resque.god'), "config/god/resque.god"
    end
  end
end
