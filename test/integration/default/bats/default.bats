#!/usr/bin/env bats

@test "logstash should exist" {
  [ -e /opt/logstash/bin/logstash ]
}

@test "configuration directory should exist" {
  [ -d /etc/logstash ]
  [ -d /etc/logstash/conf.d ]
}

@test "system.conf should get exist" {
  [ -e /etc/logstash/conf.d/system.conf ]
}

@test "upstart init file should exist" {
  [ -e /etc/init/logstash.conf ]
}

@test "logstash user should exist" {
  run id logstash
  [ "$status" -eq 0 ]
}

@test "logstash group should exist" {
  run grep "logstash:" /etc/group
  [ "$status" -eq 0 ]
}

@test "logstash user should be member of adm" {
  run egrep '^adm:.*logstash.*$' /etc/group
  [ "$status" -eq 0 ]
}

@test "logstash user should be member of root" {
  run egrep '^root:.*logstash.*$' /etc/group
  [ "$status" -eq 0 ]
}

@test "logstash should be running" {
  run pgrep -u logstash java
  [ "$status" -eq 0 ] 
}
