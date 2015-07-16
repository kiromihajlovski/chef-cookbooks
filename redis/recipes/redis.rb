#
# Cookbook Name:: redis
# Recipe:: redis
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


# Install redis server

if node["filesystem"]["/dev/xvdb"] and node["filesystem"]["/dev/xvdb"]["mount"] == '/mnt' and node["filesystem"]["/dev/xvdb"]["kb_available"].to_i > 5000000
  directory node[:redisio][:default_settings][:datadir] do
    owner node[:redisio][:user]
    group node[:redisio][:group]
    mode 0755
    action :create
    recursive true
  end
end

directory "#{node[:redisio][:log]}/redis" do
  owner node[:redisio][:user]
  group node[:redisio][:group]
  mode 0755
  action :create
  recursive true
end

# include_recipe "redisio::install"
include_recipe "redisio::enable"
