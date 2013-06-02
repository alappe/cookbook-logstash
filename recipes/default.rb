#
# Cookbook Name:: logstash
# Recipe:: default
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

if node['logstash']['allow_secure_remote_logging'] == true
  include_recipe "logstash::ssh_remote_logging"
end

group node['logstash']['user'] do
  action :create
end

user node['logstash']['user'] do
  gid node['logstash']['user']
  action :create
  comment 'logstash user'
  system true
end

node['logstash']['additional_groups'].each do |grp|
  group grp do
    members node['logstash']['user']
    append true
    action :modify
  end
end

directory node['logstash']['working_directory'] do
  owner node['logstash']['user']
  group node['logstash']['group']
  mode 00760
  action :create
end

remote_file node['logstash']['binary'] do
  checksum node['logstash']['checksum']
  source node['logstash']['source']
  user node['logstash']['user']
  group node['logstash']['group']
end

template '/etc/init/logstash.conf' do
  source 'logstash-init.conf.erb'
  owner node['logstash']['user']
  group node['logstash']['group']
  mode 00644
  variables(
    :working_directory => node['logstash']['working_directory'],
    :configuration_directory => node['logstash']['configuration_directory'],
    :binary_path => node['logstash']['binary'],
    :user => node['logstash']['user'],
    :group => node['logstash']['group'],
    :java_options => node['logstash']['java_options']
  )
end

service 'logstash' do
  provider Chef::Provider::Service::Upstart
  supports :start => true, :restart => true, :stop => true, :status => true
  action :nothing
end

directory node['logstash']['configuration_directory'] do
  owner node['logstash']['user']
  group node['logstash']['group']
  mode 00760
  action :create
  recursive true
end

node['logstash']['configuration'].each do |config|
  config.each do |filename, values|
    template "#{node['logstash']['configuration_directory']}/#{filename}" do
      source 'logstash.conf.erb'
      owner node['logstash']['user']
      group node['logstash']['group']
      mode 00644
      variables(
        :config => values
      )
    end
  end
end

service 'logstash' do
  action [:enable, :start]
end
