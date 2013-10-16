# == Class: bamboo
#
# Full description of class bamboo here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { bamboo:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class bamboo::config {

  File {
    owner => $bamboo::user,
    group => $bamboo::group,
  }

  file { "${bamboo::homedir}/logs":
    ensure  => directory,
  } ->

  file { "${bamboo::webappdir}/webapp/WEB-INF/classes/bamboo-init.properties":
    content => template('bamboo/bamboo-init.properties.erb'),
    mode    => '0755',
  } ~>

  file { "${bamboo::webappdir}/conf/wrapper.conf":
    content => template('bamboo/wrapper.conf.erb'),
    mode    => '0755',
  } ~>

  file { "${bamboo::webappdir}/bamboo.sh":
    ensure  => present,
    content => template('bamboo/bamboo.sh.erb'),
    mode    => '0700'
  } ~>

  file { '/etc/init.d/bamboo':
    ensure => link,
    target => "${bamboo::webappdir}/bamboo.sh",
  } ~>

  file { '/etc/default/bamboo':
    ensure  => present,
    content => template('bamboo/bamboo-default.erb'),
    require => Class['bamboo::install'],
    notify  => Class['bamboo::service'],
  }


}
