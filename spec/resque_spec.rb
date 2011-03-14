require File.join(File.dirname(__FILE__), 'spec_helper.rb')

class ResqueManifest < Moonshine::Manifest::Rails
end

describe "A manifest with the Resque plugin" do

  before do
    @manifest = ResqueManifest.new
  end

  it "should be executable" do
    @manifest.should be_executable
  end

  describe "using the `resque` recipe" do
    before do
      @manifest.resque
    end

    it "should install the resque and yajl-ruby packages" do
      @manifest.packages.keys.should include('resque')
      @manifest.packages.keys.should include('yajl-ruby')
    end

    it "should install specified resque gem version or default to latest" do
      @manifest.packages['resque'].ensure.should == :latest
      @manifest.resque(:version => '1.6.1')
      @manifest.packages['resque'].ensure.should == '1.6.1'
    end
  end

  describe "resque_web" do
    before do
      @manifest.configure({
        :deploy_to => '/srv/app',
        :domain => 'example.com',
        :passenger => {:rack_env => 'testing'},
        :user => 'rails'
      })
      @manifest.configure({:resque => {:web => {:username => "test",:password => "test"}}})
    end
    
    it "should install the resque web config.ru" do
      @manifest.resque_web
      @manifest.files['/srv/app/shared/resque_web/config.ru'].should_not be(nil)
    end
    
    it "should configure a username and password for resque web" do
      @manifest.configure(:resque => {:web => {:username => 'resque', :password => 'sekrit'}})
      @manifest.resque_web
      config_ru = @manifest.files['/srv/app/shared/resque_web/config.ru']['content']
      config_ru.should include('AUTH_USERNAME = "resque"')
      config_ru.should include('AUTH_PASSWORD = "sekrit"')
    end

    it "should install the resque web apache vhost" do
      @manifest.resque_web
      @manifest.files['/etc/apache2/sites-available/resque_web'].should_not be(nil)
    end

    it "should set a default port for the apache vhost" do
      @manifest.resque_web
      @manifest.files['/etc/apache2/sites-available/resque_web']['content'].should include('8282')
    end

    it "should allow a custom port for the appache vhost" do
      @manifest.configure(:resque => {:web => {:port => '1234'}})
      @manifest.resque_web
      @manifest.files['/etc/apache2/sites-available/resque_web']['content'].should include('1234')
    end

    it "should ensure that the latest version of thin is installed" do
      @manifest.resque_web
      @manifest.packages.keys.should include('thin')
      @manifest.packages['thin'].ensure.should  == :latest
    end

    it "should ensure that version 1.1.3 of sinatra is installed" do
      @manifest.resque_web
      @manifest.packages.keys.should include('sinatra')
      @manifest.packages['sinatra'].ensure.should  == '1.1.3'
    end
    
    it "should install specified version of thin or sinatra" do
      @manifest.configure({
        :resque => {
          :web => {
            :gems => {
              :thin => {:version  => '1.2.3'}, 
              :sinatra => {:version => '4.5.6'}              
            }
          }
        }
      })
      @manifest.resque_web
      @manifest.packages['thin'].ensure.should  == '1.2.3'
      @manifest.packages['sinatra'].ensure.should  == '4.5.6'
    end
    
    it "should add resque web with no config passed" do
      @manifest.configure({:resque => {}})
      @manifest.resque_web
    end
  end
end
