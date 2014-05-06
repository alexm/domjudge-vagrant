class domjudge::judgehost(
  $mysql_database      = 'domjudge',
  $mysql_user          = 'domjudge_jury',
  $mysql_password,
  $mysql_ssl_cert,
  $mysql_ssl_key,
  $mysql_ssl_ca        = ""
) inherits domjudge {

  include mysql::client

  package {
    'cgroup-lite':
      ensure => present;

    'domjudge-judgehost':
      ensure  => present,
      require => Package['cgroup-lite'];
  }
}
