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
      sudo "god status resque || true"
    end

    desc "unmonitor resque workers"
    task :unmonitor, :roles => :resque do
      sudo "god unmonitor resque"
    end

    desc "monitor resque workers"
    task :monitor, :roles => :resque do
      sudo "god monitor resque"
    end

    desc "unmonitor resque, then send QUIT signal to exit after current job is processed"
    task :quit, :roles => :resque do
      sudo "god unmonitor resque"
      sudo "god signal resque QUIT"
    end

    desc "pause working new resque jobs without killing the process."
    task :pause, :roles => :resque do
      sudo "god signal resque USR2"
    end

    desc "resume working jobs after receving a pause command."
    task :resume, :roles => :resque do
      sudo "god signal resque CONT"
    end

  end
end
