#
# Cookbook Name:: infra-messaging
# Recipe:: default
#
# Copyright 2012, John Dewey
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

class ::Chef::Recipe
  include ::Openstack
end

rabbit_server_role = node["nova"]["rabbit_server_chef_role"]
user = node['infra-messaging']['user']
pass = service_password "rabbit"
cookie = service_password "rabbit_cookie"

node.set['rabbitmq']['default_user'] = user
node.set['rabbitmq']['default_pass'] = pass
node.set['rabbitmq']['erlang_cookie'] = cookie
node.set['rabbitmq']['cluster_disk_nodes'] = search(:node, "roles:#{rabbit_server_role}").map do |n|
  "rabbit@#{n['hostname']}"
end

include_recipe "rabbitmq"
