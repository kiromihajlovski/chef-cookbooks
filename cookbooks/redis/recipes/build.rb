unless File.exist?('/etc/redis') then 

  execute "gem install redis" do
    command "gem install redis"
  end

  execute "download redis" do
    command "cd /etc && wget http://download.redis.io/releases/redis-3.0.2.tar.gz"
  end

  execute "untar redis" do
    command "cd /etc && tar -zxvf redis-3.0.2.tar.gz"
  end

  execute "move redis" do
    command "cd /etc && mv redis-3.0.2/ redis"
  end

  execute "install redis" do
   command "cd /etc/redis && make install"
  end
end