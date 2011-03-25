namespace :god do
  namespace :resque do
    desc "restart resque workers"
    task :restart, :roles => :resque do
      sudo "god restart resque"
    end
    
    desc "stop resque workers"
    task :stop, :roles => :resque do
      sudo "god stop resque; true"
    end
    
    desc "start resque workers"
    task :start, :roles => :resque do
      sudo "god start resque"
    end
    
    desc "show status of resque workers"
    task :status, :roles => :resque do
      sudo "god status resque"
    end
  end
end
