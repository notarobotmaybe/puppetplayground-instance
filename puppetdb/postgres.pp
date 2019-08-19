class { 'postgresql':
  wal_level           => 'minimal',
  max_wal_senders     => '0',
  checkpoint_segments => '8',
  wal_keep_segments   => '1',
  version             => '11',
  manage_service      => false,
}

postgresql::hba_rule { 'IPv4/any puppetdb':
  user     => 'puppetdb',
  database => 'puppetdb',
  address  => '0.0.0.0/0',
}
