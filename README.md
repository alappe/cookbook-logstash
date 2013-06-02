logstash Cookbook
=================

Very simple and small cookbook to install logstash. All external
dependencies such as e.g. RabbitMQ or redis for input and ElasticSearch
for indexing are *not included* – you have to care about them yourself.

I prefer this to the all-included cookbooks because I do not want to
have apache2 running on every box if I do not use it. If this way is not
for you, find another cookbook – there are several options.

Requirements
------------

#### cookbooks

This cookbook depends on the `java` cookbook to run the logstash.jar.

Attributes
----------

#### logstash::default
| Key | Type | Description | Default |
|-----|------|-------------|---------|
|<tt>['logshtash']['user']</tt>|String|The user for logstash to run with|<tt>logstash</tt>|
|<tt>['logshtash']['group']</tt>|String|The group for logstash to run with|<tt>logstash</tt>|
|<tt>['logshtash']['additional_groups']</tt>|Array|Array of groups the logstash user should be part of. Some system groups are needed to access the local logfiles…|<tt>['adm','root']</tt>|
|<tt>['logshtash']['working_directory']</tt>|String|Working directory for logstash|<tt>/opt/logstash</tt>|
|<tt>['logshtash']['java_options']</tt>|String|Options to pass to the JVM|<tt>-Xms512m -Xmx512m</tt>|
|<tt>['logshtash']['binary']</tt>|String|Location for the logstash binary|<tt>/usr/local/bin/logstash.jar</tt>|
|<tt>['logshtash']['source']</tt>|String|Location to download logstash jar file from|<tt>https://logstash.objects.dreamhost.com/release/logstash-1.1.13-flatjar.jar</tt>|
|<tt>['logshtash']['checksum']</tt>|String|SHA-256 checksum of jar-file|<tt>5ba0639ff4da064c2a4f6a04bd7006b1997a6573859d3691e210b6855e1e47f1</tt>|
|<tt>['logshtash']['configuration_directory']</tt>|String|Directory to place configuration files inside. Will be created.|<tt>/etc/logstash/conf.d'</tt>|
|<tt>['logshtash']['allow_secure_remote_logging']</tt>|Boolean|Create a user and allow public key access over ssh for him.|<tt>false</tt>|
|<tt>['logshtash']['secure_remote_logging']['user']</tt>|String|User to create for remote logging|<tt>logging</tt>|
|<tt>['logshtash']['secure_remote_logging']['group']</tt>|String|Group to create for remote logging|<tt>logging</tt>|
|<tt>['logshtash']['secure_remote_logging']['comment']</tt>|String|Comment to create for remote logging user|<tt>logging</tt>|
|<tt>['logshtash']['secure_remote_logging']['home']</tt>|String|Home directory for remote logging user|<tt>/home/logging</tt>|
|<tt>['logshtash']['secure_remote_logging']['remote_role']</tt>|String|Role to search for. Node with this role are supposed to expose a public key which will then be added to this users authorized_keys file|<tt>/home/logging</tt>|
|<tt>['logshtash']['configuration']</tt>|Array|Contains configuration hashes as detailed below|See attributes file|

#### configuration hashes

The `['logstasj']['configuration']`-Array should contain hashes in the
following form to write a valid configuration file.

```ruby
'system.conf' => {
	'input' => {
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
	},
	'filter' => {
		'multiline' => {
			'type' => 'syslogs',
			'what' => 'previous',
			'pattern' => '^\t'
		}
	},
	'output' => {
	  'elasticsearch_http' => {
		  'host' => '127.0.0.1',
			'flush_size' => 1
		}
	}
}
```

You can split your configuration in as many files as you need to. They
will be read in the order of the filenames and executed as if they'd be
concatenated into one big file.

Strings in the ruby configuration are automatically quoted in the
configuration file, booleans, numbers and arrays are printed as given.
This way should allow to write every statement logstash configuration
can handle.

Usage
-----
#### logstash::default

Just include `logstash` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[logstash]"
  ]
}
```

and configure what you want to log and whether you want to create a user
to allow ssh-remote-logging.

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

Authors
-------

* Andreas Lappe

License
-------

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
