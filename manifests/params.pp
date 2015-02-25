# == Class bamboo::params
#
# This class is meant to be called from bamboo.
# It sets variables according to platform.
#
class bamboo::params {
  #  case $::osfamily {
  #    'Debian': {
  #      $package_name = 'bamboo'
  #      $service_name = 'bamboo'
  #    }
  #    'RedHat', 'Amazon': {
  #      $package_name = 'bamboo'
  #      $service_name = 'bamboo'
  #    }
  #    default: {
  #      fail("${::operatingsystem} not supported")
  #    }
  #  }
}
