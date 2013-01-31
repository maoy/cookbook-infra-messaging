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

include_recipe "rabbitmq"
include_recipe "rabbitmq::mgmt_console"

# Restart rabbit with default settings, before moving on.
# Using execute to make the change immediate vs delaying.
# I could have continued to use service, but the callbacks
# get annoying.
execute "service rabbitmq-server restart" do
  not_if { ::File.exists? "/var/lib/rabbitmq/.reset_mnesia_database" }
end

class ::Chef::Recipe
  include ::Openstack
end

rabbit_server_role = node["nova"]["rabbit_server_chef_role"]
user = node["nova"]["rabbit"]["username"]
pass = user_password user
cookie = service_password "rabbit_cookie"
vhost = node["nova"]["rabbit"]["vhost"]

node.override["rabbitmq"]["default_user"] = user
node.override["rabbitmq"]["default_pass"] = pass
node.override["rabbitmq"]["erlang_cookie"] = cookie
node.override["rabbitmq"]["cluster"] = true
node.override["rabbitmq"]["cluster_disk_nodes"] = search(:node, "roles:#{rabbit_server_role}").map do |n|
  "#{user}@#{n['hostname']}"
end

rabbitmq_user "guest" do
  action :delete
end

rabbitmq_vhost vhost do
  action :add
end

rabbitmq_user user do
  password pass

  action :add
end

rabbitmq_user user do
  vhost       vhost
  permissions '".*" ".*" ".*"'

  action :set_permissions
end

# Necessary for graphing.  The guest user
# by default is admin, since we delete
# this user, I don't see too much harm in
# making the rabbit user an administrator.
rabbitmq_user user do
  user_tag "administrator"

  action :set_user_tags
end

# Re-configure rabbit to use clustering, by using the
# the node.override attributes from above.
include_recipe "rabbitmq"

# Remove the mnesia database. This is necessary so the nodes
# in the cluster will be able to recognize one another.
execute "Reset mnesia" do
  cwd "/var/lib/rabbitmq"
  command <<-EOH
    service rabbitmq-server stop;
    rm -rf mnesia/;
    touch .reset_mnesia_database;
    service rabbitmq-server start
  EOH

  not_if { ::File.exists? "/var/lib/rabbitmq/.reset_mnesia_database" }
end
