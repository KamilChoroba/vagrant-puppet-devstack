class { 'devstack':
  version            => 'stable/icehouse',
  enabled_components => ['ceilometer', 'swift', 'neutron'],
  execute_devstack   => 'false',
}
