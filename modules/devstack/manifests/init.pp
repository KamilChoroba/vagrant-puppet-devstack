# = Class: devstack
#
# This class downloads, configures and executes devstack script.sh to install devstack on local vm.
#
# == Parameters:
#
# $version:: String to specify which version of devstack should be installed. Default is stable/icehouse
#
# $ceilometer_enabled:: Boolean feature switch to enable/disable ceilometer. Default is enabled = true
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
#   $ceilometer_enabled => true,
# }
#
class devstack ($version = 'stable/icehouse', $ceilometer_enabled = 'true') {
  package { 'git':
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
  }

  file { 'local.conf':
    ensure  => file,
    path    => '/home/vagrant/devstack/local.conf',
    content => template('devstack/local.conf.erb'),
    require => Vcsrepo['devstack'],
    owner   => 'vagrant',
    group   => 'vagrant',
  }
}
