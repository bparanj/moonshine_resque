class MoonshineResqueGodGenerator < Rails::Generators::Base
  desc Pathname.new(__FILE__).dirname.join('..', '..', '..', 'generators', 'moonshine_resque_god', 'USAGE').read

  def self.source_root
    @_moonshine_resque_god_source_root ||= Pathname.new(__FILE__).dirname.join('..', '..', '..', 'generators', 'moonshine_resque_god', 'templates')
  end

  def manifest
    template "resque.god", "config/god/resque.god"
  end

  intro = <<-INTRO

- To monitor Resque with God, install moonshine_god.

  script/plugin install git://github.com/railsmachine/moonshine_god.git

You'll also want to add the `:resque` role to all servers using it.
For example:

  # config/deploy/production.rb
  server 'worker1.myapp.com', :app, :resque

We also strongly recommend having Moonshine automatically restart Resque on
deploys:

  # config/deploy.rb
  before 'god:restart', 'god:resque:stop'

This is a great way to handle automatically reloading new app code into your
workers on deploy, as well as increasing or decreasing the number of
Resque workers.

INTRO

  puts intro if File.basename($0) == 'generate'    
end
