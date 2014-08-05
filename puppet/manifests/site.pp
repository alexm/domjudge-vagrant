node default {
  class { 'apt':
    always_apt_update => true
  }

  $certs    = '/vagrant/puppet/private/certs'
  $dbserver = $::ipaddress
  $dbname   = 'domjudge'
  $dbuser   = 'domjudge_jury'
  $dbpass   = 'vagrant'

  # mysqld apparmor profile won't read PEM files
  # unless they're inside /etc/mysql
  file {
    '/etc/mysql/ca-cert.pem':
      ensure => present,
      source => "${certs}/ca-cert.pem",
      owner  => 'root',
      group  => 'mysql',
      mode   => '0640';

    '/etc/mysql/server-cert.pem':
      ensure => present,
      source => "${certs}/server-cert.pem",
      owner  => 'root',
      group  => 'mysql',
      mode   => '0640';

    '/etc/mysql/server-key.pem':
      ensure => present,
      source => "${certs}/server-key.pem",
      owner  => 'root',
      group  => 'mysql',
      mode   => '0640';
  }

  class { 'mysql::server':
    root_password      => 'vagrant',
    restart            => true,
    override_options   => {
      'mysqld'         => {
        'bind-address' => $dbserver,
        'ssl'          => 'true',
        'ssl-ca'       => '/etc/mysql/ca-cert.pem',
        'ssl-cert'     => '/etc/mysql/server-cert.pem',
        'ssl-key'      => '/etc/mysql/server-key.pem',
      }
    },
    grants => {
      "${dbuser}@${dbserver}/${dbname}.*" => {
        ensure     => present,
        options    => ['GRANT'],
        privileges => ['ALL'],
        table      => "${dbname}.*",
        user       => "${dbuser}@${dbserver}",
      },
    },
    users => {
      "${dbuser}@localhost" => {
        ensure => absent,
      },
      "${dbuser}@${dbserver}" => {
        ensure        => present,
        password_hash => mysql_password($dbpass),
      },
    },
  }

  # puppetlabs-mysql does not support requiring ssl option
  exec { "require ssl for ${dbuser} in mysql":
    command => "/usr/bin/mysql -e \"GRANT USAGE ON *.* TO '${dbuser}'@'${dbserver}' REQUIRE SSL;\"",
    require => Class['mysql::server'],
  }

  class { 'domjudge::domserver':
    dbpass   => $dbpass,
    dbserver => $dbserver,
  }

  class { 'domjudge::judgehost':
    dbpass   => $dbpass,
    dbserver => $dbserver,
  }
}
