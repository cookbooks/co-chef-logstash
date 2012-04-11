#
# Cookbook Name:: logstash
# Attributes:: default
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

default['logstash']['version']  = "1.1.0"
default['logstash']['checksum'] = "6c9f491865b5eed569e029f6ad9f3343f346cfa04d04314e7aadea7b9578490f"
default['logstash']['source'] = "http://semicomplete.com/files/logstash/"

default['logstash']['install_path'] = "/opt/logstash"
default['logstash']['config_path']  = "/etc/logstash"
default['logstash']['log_path']     = "/var/log/logstash"
default['logstash']['pattern_path'] = nil # if you have grok installed, you can set this and the agent will use it

# Can be one or both of: 'agent', 'web'
default['logstash']['component'] = [ 'agent', 'web' ]

# set this to false requires you to get your logstash agent config files in :config_path BEFORE this recipe is run
default['logstash']['default_agent_config'] = true 

default['logstash']['user_login'] = 'logstash'
default['logstash']['user_uid']   = 61022

default['logstash']['user_group']     = 'logstash'
default['logstash']['user_group_gid'] = 61022

# Memory (MB)
default['logstash']['java_agent'] = '256'
default['logstash']['java_web']   = '256'
  
# AMQP broker - Used for the default agent config
default['logstash']['amqp']['host'] = 'localhost'
default['logstash']['amqp']['type'] = 'all'
default['logstash']['amqp']['exchange'] = 'rawlogs'
default['logstash']['amqp']['name'] = 'rawlogs_consumer'
default['logstash']['amqp']['user'] = 'guest'
default['logstash']['amqp']['password'] = 'guest'

# System init script style
# Set to nil to automatically pick the appropriate style based on OS.
# Possible explicit values include:
#   runit [for ubuntu, debian, gentoo ]
#   daemonize [ for RH, centos, scientific]
#
default['logstash']['init_style'] = nil

default['logstash']['elasticsearch']['embedded'] = true
default['logstash']['elasticsearch']['host']     = 'localhost'
default['logstash']['elasticsearch']['cluster']  = nil
