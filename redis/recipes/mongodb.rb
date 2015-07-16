#
# Cookbook Name:: couponing
# Recipe:: mongodb
#
# Copyright 2013, Cuponation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# MongoDB install
# Check recipe attributes for configuration 

# There may be not enough space on root partition, so if /mnt mounted to /dev/xvdb
# and there is enough free space, bind mount /usr/local/mongodb to /mnt/mount_mongodb

Chef::Log.info("Install Mongodb")

if node["filesystem"]["/dev/xvdb"]
  if node["filesystem"]["/dev/xvdb"]["mount"] == '/mnt' and node["filesystem"]["/dev/xvdb"]["kb_available"].to_i > 5000000

    directory "/mnt/mount_mongodb" do
      owner node[:mongodb][:user]
      group node[:mongodb][:group]
      mode 0755
      action :create
    end

    directory "/usr/local/mongodb" do
      owner node[:mongodb][:user]
      group node[:mongodb][:group]
      mode 0755
      action :create
    end

    directory "/mnt/mount_mongodb_journal" do
      owner node[:mongodb][:user]
      group node[:mongodb][:group]
      mode 0755
      action :create
    end

    directory "/var/lib/mongodb" do
      owner node[:mongodb][:user]
      group node[:mongodb][:group]
      mode 0755
      action :create
    end

    mount "/usr/local/mongodb" do
      device "/mnt/mount_mongodb"
      fstype "none"
      options "bind,rw"
      action [:mount, :enable]
    end

    mount "/var/lib/mongodb" do
      device "/mnt/mount_mongodb_journal"
      fstype "none"
      options "bind,rw"
      action [:mount, :enable]
    end

  end
end


directory "#{node[:mongodb][:logpath]}" do
  owner node[:mongodb][:user]
  group node[:mongodb][:group]
  mode 0755
  recursive true
end

# Mongodb installation properly tested on Ubuntu hosts only
include_recipe "mongodb::10gen_repo"
include_recipe "mongodb"

mongodb_instance "mongodb" do
  port node[:mongodb][:port]
  dbpath node[:mongodb][:config][:dbpath]
  logpath node[:mongodb][:config][:logpath]
  package_version node[:mongodb][:package_version]
end

cookbook_file "/etc/init.d/mongodb" do
  source "mongodb_init"
  owner node[:mongodb][:user]
  group node[:mongodb][:group]
  mode 0755
end

include_recipe "monit"
monit_monitrc "mongodb"
