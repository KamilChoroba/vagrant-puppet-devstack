# = Class: devstack
#
# This class downloads, configures and executes devstack script.sh to install devstack on local vm.
#
# == Parameters:
#
# $version:: String to specify which version of devstack should be installed. Default is stable/icehouse
#
# $ceilometer_enabled:: Array containing Strings which services should be enabled. Default is empty
#
# $execute_devstack:: boolean string to decide wheter stack.sh should be executed or not. Default is true
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
# include devstack
#
# or
#
# class { 'devstack':
#   $version            => 'stable/icehouse',
#   $ceilometer_enabled => ['ceilometer', 'neutron', 'swift'],
#   $execute_devstack   => 'true',
# }
#
class devstack ($version = 'stable/icehouse', $enabled_components = [], $execute_devstack = 'true') {
  package { ['git', 'memcached', 'vim']:
    ensure => 'installed',
  }

  vcsrepo { 'devstack':
    path     => '/home/vagrant/devstack',
    ensure   => present,
    provider => git,
    source   => 'https://github.com/openstack-dev/devstack.git',
    revision => $version,
    owner    => 'vagrant',
    group    => 'vagrant',
    require  => Package['git'],
  }

  file { 'local.conf':
    ensure  => file,
    path    => '/home/vagrant/devstack/local.conf',
    content => template('devstack/local.conf.erb'),
    owner   => 'vagrant',
    group   => 'vagrant',
    require => Vcsrepo['devstack'],
  }

  if $execute_devstack == 'true' {
    exec { 'stack.sh':
      command     => '/home/vagrant/devstack/stack.sh',
      cwd         => '/home/vagrant/devstack',
      environment => ['HOME=/home/vagrant'],
      group       => 'vagrant',
      user        => 'vagrant',
      logoutput   => 'on_failure',
      timeout     => 0,
      require     => Package['memcached'],
    }
  }

  #  exec { 'unstack.sh':
  #    command   => '/home/vagrant/devstack/unstack.sh',
  #    cwd       => '/home/vagrant/devstack',
  #    group     => 'vagrant',
  #    user      => 'vagrant',
  #    logoutput => 'on_failure',
  #    timeout   => 0,
  #    before    => Exec['stack.sh'],
  #  }
}
