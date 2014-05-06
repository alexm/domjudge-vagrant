class domjudge::domserver(
  $mysql_root_password,
  $mysql_database = 'domjudge',
  $mysql_user     = 'domjudge_jury',
  $mysql_password,
  $mysql_ssl_cert,
  $mysql_ssl_key,
  $mysql_ssl_ca   = ""
) inherits domjudge {

  package {
    'domjudge-domserver':
      ensure => present;
  }

  file {
    '/etc/apache2/conf.d/domjudge':
      ensure  => link,
      target  => '/etc/domjudge/apache.conf',
      require => Package['domjudge-domserver'],
      notify  => Service['apache2'];
  }

  service { 'apache2': }

  class {
    'mysql::server':
      root_password    => $mysql_root_password,
      override_options => {
        'mysqld'         => {
          'bind-address' => $::ipaddress,
          'ssl'          => 'true',
          'ssl-ca'       => $mysql_ssl_ca,
          'ssl-cert'     => $mysql_ssl_cert,
          'ssl-key'      => $mysql_ssl_key,
        }
      },
      grants => {
        "${mysql_user}@${::ipaddress}/${mysql_database}.*" => {
          ensure     => present,
          options    => ['GRANT'],
          privileges => ['ALL'],
          table      => "${mysql_database}.*",
          user       => "${mysql_user}@${::ipaddress}",
        },
      },
      users => {
        "${mysql_user}@localhost" => {
          ensure => absent,
        },
        "${mysql_user}@${::ipaddress}" => {
          ensure        => present,
          password_hash => mysql_password('vagrant'),
        },
      },
  }
}
