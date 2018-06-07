class { 'postgresql':
  wal_level           => 'hot_standby',
  max_wal_senders     => '3',
  checkpoint_segments => '8',
  wal_keep_segments   => '8',
  version             => '9.6',
}

postgresql::hba_rule { 'IPv4/any puppetdb':
  user     => 'puppetdb',
  database => 'puppetdb',
  address  => '0.0.0.0/0',
}

postgresql::role { 'puppetdb':
  password => 'X_PUPPETDB_PASSWORD_X',
}

postgresql::db { 'puppetdb':
  owner => 'puppetdb',
}
