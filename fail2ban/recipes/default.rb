#
# Cookbook Name:: fail2ban
# Recipe:: default
#
# Copyright 2015, Cuponation
#
# All rights reserved - Do Not Redistribute
#


directory "/etc/iptables" do
	mode "0755"
	owner "root"
	group "root"
	action :create
end

template "/etc/iptables/iptables.rules" do
	source "iptables.rules.erb"
	mode "0755"
	owner "root"
	group "root"
end

execute "firewall up" do
	command "iptables-restore < /etc/iptables/iptables.rules"
end

template "/etc/network/if-pre-up.d/iptablesload" do 
	source "iptablesload.erb"
	mode "755"
end

template "/etc/network/if-post-down.d/iptablessave" do 
	source "iptablessave.erb"
	mode "755"
end

package "nginx" do
	action :install
end
service "nginx" do
	action [:enable, :start]
end

package "fail2ban" do
	action :install
end

service "fail2ban" do
	action [:enable, :start]
end

remote_directory "/etc/fail2ban/filter.d" do 
	source "filter.d"
end

template "/etc/fail2ban/jail.conf" do
	source "jail.conf.erb"
	mode "644"
	notifies :restart, "service[fail2ban]"
end
