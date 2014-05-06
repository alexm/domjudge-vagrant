node default {
  class { 'apt': always_apt_update => true }
  include stdlib

  file {
    '/etc/mysql/server-cert.pem':
      ensure  => present,
      content => file('/etc/ssl/certs/ssl-cert-snakeoil.pem'),
      owner   => 'mysql',
      group   => 'mysql',
      mode    => '0600',
      require => Class['mysql::server'];

    '/etc/mysql/server-key.pem':
      ensure  => present,
      content => file('/etc/ssl/private/ssl-cert-snakeoil.key'),
      owner   => 'mysql',
      group   => 'mysql',
      mode    => '0600',
      require => Class['mysql::server'];
  }

  $mysql_options = {
    'mysql_database' => 'domjudge',
    'mysql_user'     => 'domjudge_jury',
    'mysql_password' => 'vagrant',
    'mysql_ssl_cert' => '/etc/mysql/server-cert.pem',
    'mysql_ssl_key'  => '/etc/mysql/server-key.pem',
  }

  $domserver_options = merge($mysql_options, {
    'mysql_root_password' => 'vagrant',
  })

  $domjudge_classes = {
    'domjudge::domserver' => $domserver_options,
    'domjudge::judgehost' => $mysql_options,
  }

  create_resources('class', $domjudge_classes)
}
