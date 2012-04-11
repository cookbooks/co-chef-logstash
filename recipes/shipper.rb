#
# Cookbook Name:: logstash
# Recipe:: shipper
#
# Copyright 2012, Brad Montgomery
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

inputs = []
node['logstash']['data_bag_items'].each do |item|
  search(:logstash, "id:#{item}") do |input_data|
    inputs = inputs + input_data['inputs']
  end
end

template "#{node['logstash']['config_path']}/shipper.conf" do
  source "shipper.conf.erb"
  owner "root"
  group root_group
  mode 0644
  variables(
    :inputs => inputs
  )
  unless node['logstash']['init_style'] == "supervisord"
    notifies :restart, "service[logstash-agent]"
  end
end
