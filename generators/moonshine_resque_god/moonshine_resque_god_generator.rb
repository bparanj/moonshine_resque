class MoonshineResqueGodGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory File.join("config", "god")
      m.template "resque.god", "config/god/resque.god"
    
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
      
      puts intro
    end
  end
end
