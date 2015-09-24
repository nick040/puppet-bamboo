# == Class bamboo::install
#
# This class is called from bamboo for install.
#
class bamboo::install (
  $javahome     = $bamboo::javahome,
  $installdir   = $bamboo::installdir,
  $homedir      = $bamboo::homedir,
  $user         = $bamboo::user,
  $group        = $bamboo::group,
  $shell        = $bamboo::shell,
  $webappdir    = $bamboo::webappdir,
  $downloadURL  = $bamboo::downloadURL,
  $file         = $bamboo::file,
  $os_home      = $bamboo::os_home,
) {

  $_os_home = $os_home? {
    undef   =>  "/home/${user}",
    default => $os_home,
  }

  if ! defined(User[$user]) {
    user { $user:
      shell            => $shell,
      password         => '*',
      password_min_age => '0',
      password_max_age => '99999',
      home             => $_os_home,
      managehome       => false,
      system           => true,
    }

    if ! defined(File[$_os_home]) {
      file { $_os_home:
        ensure => 'directory',
        owner  => $user,
        group  => $user,
        mode   => '0700',
      }
    }
  }

  file { $installdir:
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    require => User[$user],
  } ->

  file { $webappdir:
    ensure => 'directory',
    owner  => $user,
    group  => $group,
  }

  staging::file { $file:
    source  => "${downloadURL}/${file}",
    timeout => 1800,
  } ->

  staging::extract { $file:
    target  => $webappdir,
    creates => "${webappdir}/conf",
    strip   => 1,
    user    => $user,
    group   => $group,
    notify  => Exec["chown_${webappdir}"],
    before  => File[$homedir],
    require => [
      File[$installdir],
      User[$user],
      File[$webappdir] ],
  }

  if ! defined(File[$homedir]) {
    file { $homedir:
      ensure  => 'directory',
      owner   => $user,
      group   => $group,
    }
  }

  file { "${homedir}/.subversion":
    ensure => 'directory',
    owner  => $user,
    group  => $group,
    mode   => '0750',
  } ->

  file { "${homedir}/.sonar":
    ensure => 'directory',
    owner  => $user,
    group  => $group,
    mode   => '0750',
  } ->

  file { "${_os_home}/.subversion":
    ensure => symlink,
    owner  => $user,
    group  => $group,
    target => "${homedir}/.subversion",
  } ->

  file { "${_os_home}/.sonar":
    ensure => symlink,
    owner  => $user,
    group  => $group,
    target => "${homedir}/.sonar",
  } ->

  exec { "chown_${webappdir}":
    command     => "/bin/chown -R ${user}:${group} ${webappdir}",
    refreshonly => true,
    subscribe   => User[$user]
  } ->

  file { "${installdir}/latest":
    ensure => link,
    target => "${bamboo::webappdir}",
  }

}
