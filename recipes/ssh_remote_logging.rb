#
# Cookbook Name:: logstash
# Recipe:: ssh_remote_logging.rb
#
# Copyright 2013, kaeufli.ch
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# Create a user to allow remote login and logging with it.

conf = node['logstash']['secure_remote_logging']

group conf['group'] do
  action :create
end

user conf['user'] do
  gid conf['group']
  comment conf['comment']
  system true
  action :create
end

directory conf['home'] do
  user conf['user']
  group conf['group']
  action :create
end

directory "#{conf['home']}/.ssh" do
  user conf['user']
  group conf['group']
  action :create
end

# Allow login for all nodes that have a certain role as they should
# expose their public key.
if Chef::Config[:solo]
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
else
  logstash_clients = search(:node, "roles:#{conf['remote_role']}")
end

template "#{conf['home']}/.ssh/authorized_keys" do
  source 'authorized_keys.erb'
  owner conf['user']
  group conf['group']
  mode 00600
  variables(
    :clients => logstash_clients
  )
  not_if { logstash_clients.nil? }
end
