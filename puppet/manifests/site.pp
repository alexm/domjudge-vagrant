node default {
  class { 'apt': always_apt_update => true }
  include stdlib

  $cert_files = [
    'ca-cert.pem',
    'ca-key.pem',
    'server-cert.pem',
    'server-key.pem',
    'client-cert.pem',
    'client-key.pem',
  ]

  mysql_cert_file { $cert_files: path => '/vagrant/puppet/private/certs' }

  $db_options = {
    'mysql_database' => 'domjudge',
    'mysql_user'     => 'domjudge_jury',
    'mysql_password' => 'vagrant',
    'mysql_ssl_ca'   => '/etc/mysql/ca-cert.pem',
  }

  $domserver_options = merge($db_options, {
    'mysql_root_password' => 'vagrant',
    'mysql_ssl_cert'      => '/etc/mysql/server-cert.pem',
    'mysql_ssl_key'       => '/etc/mysql/server-key.pem',
  })

  $judgehost_options = merge($db_options, {
    'mysql_ssl_cert' => '/etc/mysql/client-cert.pem',
    'mysql_ssl_key'  => '/etc/mysql/client-key.pem',
  })

  $domjudge_classes = {
    'domjudge::domserver' => $domserver_options,
    'domjudge::judgehost' => $judgehost_options,
  }

  create_resources('class', $domjudge_classes)
}

define mysql_cert_file($path)
{
  file{
    "/etc/mysql/$name":
      ensure  => present,
      source  => "${path}/${name}",
      owner   => 'mysql',
      group   => 'mysql',
      mode    => '0600',
      require => Class['mysql::server'];
  }
}
