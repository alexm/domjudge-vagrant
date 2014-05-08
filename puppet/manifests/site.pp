node default {
  class { 'apt': always_apt_update => true }
  include stdlib

  $private_certs  = '/vagrant/puppet/private/certs'
  $mysql_database = 'domjudge'
  $mysql_user     = 'domjudge_jury'
  $mysql_password = 'vagrant'

  class {
    'mysql::server':
      root_password    => 'vagrant',
      override_options => {
        'mysqld'         => {
          'bind-address' => $::ipaddress,
          'ssl'          => 'true',
          'ssl-ca'       => "${private_certs}/ca-cert.pem",
          'ssl-cert'     => "${private_certs}/server-cert.pem",
          'ssl-key'      => "${private_certs}/server-key.pem",
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

  include domjudge::domserver
  include domjudge::judgehost
}
