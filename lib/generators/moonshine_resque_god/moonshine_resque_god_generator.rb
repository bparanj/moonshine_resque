class MoonshineResqueGodGenerator < Rails::Generators::Base
  desc Pathname.new(__FILE__).dirname.join('..', '..', '..', 'generators', 'moonshine_resque_god', 'USAGE').read

  def self.source_root
    @_moonshine_resque_god_source_root ||= Pathname.new(__FILE__).dirname.join('..', '..', '..', 'generators', 'moonshine_resque_god', 'templates')
  end

  def manifest
    directory File.join("config", "god")
    template "resque.god", "config/god/resque.god"
  end

      intro = <<-INTRO

- To monitor Resque with God, install moonshine_god.

  script/plugin install git://github.com/railsmachine/moonshine_god.git

INTRO
      
      puts intro
    end
  end
end
