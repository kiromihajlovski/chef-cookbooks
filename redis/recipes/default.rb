
#
# Cookbook Name:: redis-all
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "redis::prerequirements"
include_recipe "redis::build"


node["redis-all"]["cluster"].each do |clustername, data|
  document_root = "/home/cluster/#{clustername}"
  server_name = data['cluster-port']
  directory document_root do
    mode "0755"
    recursive true
  end
  template "#{document_root}/#{server_name}.conf" do
    source "redis.conf.erb"
    variables :port => data["cluster-port"]
  end
  base_piddir = '/var/run/redis'
  piddir = "#{base_piddir}/#{server_name}"
  template "/etc/init.d/redis#{server_name}" do
        source 'redis.init.erb'
        owner 'root'
        group 'root'
        mode '0755'
        variables({
          :name => server_name,
          :port => data['cluster-port'],
          :configdir => document_root,
          :piddir => piddir,
          :required_start => node['redis']['init.d']['required_start'].join(" "),
          :required_stop => node['redis']['init.d']['required_stop'].join(" ")
          })
        
  end
  service "redis#{server_name}" do
    action [:enable, :start]
  end
end

node["redis-all"]["monitor"].each do |monitorname, data|
  document_root = "/home/monitor/#{monitorname}"
  sentinel_name = data['monitor-port']
  directory document_root do
    mode "0755"
    recursive true
  end
  template "#{document_root}/#{sentinel_name}.conf" do
    source "sentinel.conf.erb"
    variables(
      :port => data["monitor-port"],
      :master_port => data["master_port"]
    ) 
  end
base_piddir = '/var/run/redis'
piddir = "#{base_piddir}/#{sentinel_name}"

  template "/etc/init.d/redis_#{sentinel_name}" do
        source 'sentinel.init.erb'
        owner 'root'
        group 'root'
        mode '0755'
        variables({
          :name => sentinel_name,                   
          :configdir => document_root,
          :piddir => piddir,
          })
      
  end

  service "redis_#{sentinel_name}" do
    action [:enable, :start]
  end

end

  
 
 # execute "Create Cluster" do
 #   command "cd /etc/redis/src && echo 'yes' | ./redis-trib.rb create --replicas 1 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005"
 # end
