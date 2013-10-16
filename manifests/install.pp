# == Class: bamboo::install
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
class bamboo::install {

  require bamboo

  deploy::file { "atlassian-${bamboo::product}-${bamboo::version}.${bamboo::format}":
    target  => $bamboo::webappdir,
    url     => $bamboo::downloadURL,
    strip   => true,
    notify  => Exec["chown_${bamboo::webappdir}"],
  } ->

  user { $bamboo::user:
    comment          => 'Bamboo daemon account',
    shell            => '/bin/true',
    home             => $bamboo::homedir,
    password         => '*',
    password_min_age => '0',
    password_max_age => '99999',
    managehome       => true,
    system           => true,
  } ->

  file { $bamboo::homedir:
    ensure  => 'directory',
    owner   => $bamboo::user,
    group   =>  $bamboo::group,
    recurse => true,
  } ->

  exec { "chown_${bamboo::webappdir}":
    command     => "/bin/chown -R ${bamboo::user}:${bamboo::group} ${bamboo::webappdir}",
    refreshonly => true,
    subscribe   => User[$bamboo::user]
  }

}
