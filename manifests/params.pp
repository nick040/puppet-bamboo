# == Class bamboo::params
#
# This class is meant to be called from bamboo. It sets variables according to platform.
#
class bamboo::params () {
  case $::osfamily {
    /RedHat/: {
      if $::operatingsystemmajrelease == '7' {
        $json_packages           = 'rubygem-json'
        $service_file_location   = '/usr/lib/systemd/system/bamboo.service'
        $service_file_template   = 'bamboo/bamboo.service.erb'
        $service_lockfile        = '/var/lock/subsys/bamboo'
      } elsif $::operatingsystemmajrelease == '6' {
        $json_packages           = [ 'rubygem-json', 'ruby-json' ]
        $service_file_location   = '/etc/init.d/bamboo'
        $service_file_template   = 'bamboo/bamboo.initscript.redhat.erb'
        $service_lockfile        = '/var/lock/subsys/bamboo'
      } else {
        fail("${::operatingsystem} ${::operatingsystemmajrelease} not supported")
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
