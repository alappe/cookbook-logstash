# -*- mode: ruby -*-
# vi: set ft=ruby :
#require 'berkshelf/vagrant'

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.berkshelf.enabled = true
  config.vm.provision :chef_solo do |chef|
     chef.add_recipe "logstash"
     chef.json = {
       :logstash => {
         :allow_secure_remote_logging => true
       }
     }
  end
end
