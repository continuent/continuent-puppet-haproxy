#
# Copyright 2014 Continuent Inc.
#
# === License
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#                http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class haproxy(
        $haproxyUser                                                                        = 'connectorchk',
        $haproxyPassword                                                        = 'KfFjVCgZ9rKhn2L',
        $applicationPort   = 3306,
) {

                package { 'xinetd':
                        ensure => present,
                } 
                #exec { "add-service":
                #        unless        => "/bin/cat /etc/services | /bin/grep connectorchk|wc -l",
                #        command => "/bin/echo 'connectorchk                                 9200/tcp' >> /etc/services",
                #        notify        => Service['xinetd'],
                #} 
                file { "/etc/services":
                        owner => root,
                        group => root,
                        mode => 700,
                        notify        => Service['xinetd'],
                        content => template("haproxy/services.erb") ,
                }
                service { "xinetd":
                        ensure        => "running",
                        enable        => "true",
                } 
                file { "/opt/continuent/share/":
                  ensure => directory,
                  owner	=> tungsten,
                  group	=> tungsten,
                  mode => 750
                } 
                file { "/opt/continuent/share/connectorchk.sh":
                        owner => tungsten,
                        group => tungsten,
                        mode => 700,
                        content => template("haproxy/connectorchk.sh.erb") ,
                } 
                file { "/etc/xinetd.d/connectorchk":
                        owner => root,
                        group => root,
                        mode => 600,
                        content => template("haproxy/connectorchk.erb") ,
                        notify        => Service['xinetd'],
                }


}
