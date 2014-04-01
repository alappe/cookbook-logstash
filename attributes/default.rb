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

default['logstash'] = {
  'user' => 'logstash',
  'group' => 'logstash',
  'additional_groups' => ['adm', 'root'],
  'working_directory' => '/opt/logstash',
  'java_options' => '-Xms512m -Xmx512m',
  'package' => '/usr/local/src/logstash.deb',
  'source' => 'https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_1.4.0-1-c82dc09_all.deb',
  'checksum' => '3ed96012f4e19bf14a84204f92d6b21cd9f599da',
  'configuration_directory' => '/etc/logstash/conf.d',
  'log_directory' => '/var/log',
  'log_file' => 'logstash.log',
  'allow_secure_remote_logging' => false,
  'web_interface' => true,
  'secure_remote_logging' => {
    'user' => 'logging',
    'group' => 'logging',
    'comment' => 'logging remote client access user',
    'home' => '/home/logging',
    'remote_role' => 'logstash-client'
  },
  'configuration' => [
    'system.conf' => {
      'input' => [
        'file' => {
          'type' => 'linux-syslog',
          'path' => [
            '/var/log/syslog',
          ]
        },
        'file' => {
          'type' => 'mail',
          'path' => [
            '/var/log/mail.log',
            '/var/log.mail.err'
          ]
        }
      ],
      'filter' => [
        'multiline' => {
          'type' => 'syslogs',
          'what' => 'previous',
          'pattern' => '^\t'
        }
      ],
      'output' => [
      ]
    }
  ]
}
