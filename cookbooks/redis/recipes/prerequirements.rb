unless File.exist?('/etc/redis') then 
execute "apt-get update" do
  command "apt-get update"
end
end

package "build-essential" do 
  action :install 
end

package "ruby" do
  action :install 
end

package "ruby-dev" do 
  action :install 
end 