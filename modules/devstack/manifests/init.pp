class devstack {
  package { 'git':
    ensure => 'installed',
  }

  vcsrepo { 'devstack':
    path     => '/home/vagrant/devstack',
    ensure   => present,
    provider => git,
    source   => 'https://github.com/openstack-dev/devstack.git',
    revision => 'stable/icehouse',
    owner    => 'vagrant',
    group    => 'vagrant',
  }

  file { 'local.conf':
    ensure  => file,
    path    => '/home/vagrant/devstack/local.conf',
    source  => "puppet:///modules/devstack/local.conf",
    require => Vcsrepo['devstack'],
    owner   => 'vagrant',
    group   => 'vagrant',
  }

}
