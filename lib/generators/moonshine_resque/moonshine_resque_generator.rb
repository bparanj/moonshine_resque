class MoonshineResqueGenerator < Rails::Generators::Base
  desc Pathname.new(__FILE__).dirname.join('..', '..', '..', 'generators', 'moonshine_resque', 'USAGE').read

  def self.source_root
    @_moonshine_resque_source_root ||= Pathname.new(__FILE__).dirname.join('..', '..', '..', 'generators', 'moonshine_resque', 'templates')
  end

  def manifest
    plugin("moonshine_redis", :git => "git://github.com/railsmachine/moonshine_redis.git")
    template "resque.yml", "config/resque.yml"
    template "resque.rb", "config/initializers/resque.rb"
    
    gem("resque")
    gem("redis")
  end

  intro = <<-INTRO

- Be sure to install moonshine_redis to use moonshine_resque.

  script/plugin install git://github.com/railsmachine/moonshine_redis.git

- To monitor Resque with God, generate the configuration file 
  and install moonshine_god.

  script/generate moonshine_resque_god
  script/plugin install git://github.com/railsmachine/moonshine_god.git


INTRO
      
  puts intro if File.basename($0) == 'generate'
end
