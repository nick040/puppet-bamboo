puppet-bamboo
=================

This is a puppet module to install bamboo

Requirements
------------
* Puppet 3.0+ tested 
* Puppet 2.7+
* dependency 'mkrakowitzer/deploy', '>= 0.0.1'


Example
-------
```puppet
  class { 'bamboo':
    version      => '4.4.5',
    installdir   => '/opt/atlassian/atlassian-bamboo',
    homedir      => '/opt/atlassian/application-data/bamboo-home',
    user         => 'bamboo',
    group        => 'bamboo',
    javahome     => '/opt/java',
  }
```
Paramaters
----------
TODO

License
-------
The MIT License (MIT)

Contact
-------
Merritt Krakowitzer merritt@krakowitzer.com

Support
-------

Please log tickets and issues at our [Projects site](http://github.com/mkrakowitzer/puppet-bamboo)
