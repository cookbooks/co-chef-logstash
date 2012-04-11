#
# Cookbook Name:: logstash
# Recipe:: default
#
# Copyright 2011, Joshua Timberman
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

root_group = value_for_platform(
  ["openbsd", "freebsd", "mac_os_x"] => { "default" => "wheel" },
  "default" => "root"
)

group node['logstash']['user_group'] do
  gid node['logstash']['user_group_gid']
end

user node['logstash']['user_login'] do
  uid node['logstash']['user_uid']
  gid node['logstash']['user_group']
end

directory "#{node['logstash']['install_path']}" do
  owner node['logstash']['user_login']
  group node['logstash']['user_group']
  mode 0755
end

directory "#{node['logstash']['config_path']}" do
  owner "root"
  group root_group
  mode 0755
end

directory "#{node['logstash']['log_path']}" do
  owner node['logstash']['user_login']
  group node['logstash']['user_group']
  mode 0755
end

remote_file "#{node['logstash']['install_path']}/logstash-monolithic.jar" do
  source "#{node['logstash']['source']}logstash-#{node['logstash']['version']}-monolithic.jar"
  owner node['logstash']['user_login']
  group node['logstash']['user_group']
  checksum node['logstash']['checksum']
  node['logstash']['component'].each do |component|
    notifies :restart, "service[logstash-#{component}]"
  end
end

if node['logstash']['component'].include?('agent') && node['logstash']['default_agent_config']
  apache_log_dir = value_for_platform(
    ["centos", "redhat", "suse", "fedora", "arch", "scientific"] => {
      "default" => "/var/log/httpd"
    },
    "default" => {
      "default" => "/var/log/apache2"
    }
  )

  template "#{node['logstash']['config_path']}/agent.conf" do
    source "agent.conf.erb"
    owner "root"
    group root_group
    mode 0644
    notifies :restart, "service[logstash-agent]"
    variables(
      :apache_log_dir => apache_log_dir
      )
  end
end

init_style = node['logstash']['init_style']
init_style ||= value_for_platform(
  ["centos", "redhat", "suse", "fedora", "arch", "scientific"] => {
    "default" => "daemonize"
  },
  ["ubuntu", "debian"] => {
    "default" => "runit"
  },
  "default" => { "default" => "unknown" }
)

package "daemonize" do
  action :upgrade
  only_if { init_style == "daemonize" }
end

node['logstash']['component'].each do |component|
  case init_style
  when 'daemonize'
    template "/etc/init.d/logstash-#{component}" do
      source "logstash-#{component}.init.erb"
      owner "root"
      group root_group
      mode 0755
      notifies :restart, "service[logstash-#{component}]"
    end

    service "logstash-#{component}" do
      supports :status => true, :start => true, :stop => true, :restart => true
      action [:enable, :start]
    end
  when 'runit'
    runit_service "logstash-#{component}"  
  else
    service "logstash-#{component}" do
      action :nothing
    end
  end
end
