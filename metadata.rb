name             'logstash'
maintainer       'kaeufli.ch'
maintainer_email 'nd@kaeufli.ch'
license          'apache 2.0'
description      'Installs/Configures logstash'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
recipe           'logstash', 'Installs and configures logstash'

%w{ debian ubuntu }.each do |os|
  supports os
end

%w{ apt java }.each do |recipe|
  depends recipe
end
