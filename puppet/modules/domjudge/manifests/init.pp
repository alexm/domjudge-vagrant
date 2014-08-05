class domjudge {
  include apt
  include stdlib

  if $::osfamily != 'Debian' {
    fail("Unsupported osfamily: ${::osfamily}, module domjudge only supports osfamily Debian.")
  }

  apt::source { 'domjudge':
    location          => 'http://non-gnu.uvt.nl/debian',
    release           => 'squeeze',
    repos             => 'uvt',
    key               => '211A1230',
    key_server        => 'pgp.mit.edu',
  }

  Package {
    require => Apt::Source['domjudge']
  }

  package { 'domjudge-common':
    ensure => present,
  }

  File_line {
    path    => '/etc/domjudge/common-config.php',
    require => Package['domjudge-common'],
  }

  file_line {
    'common-config.php flags null':
      line  => "// define('DJ_MYSQL_CONNECT_FLAGS', null);",
      match => "define\\('DJ_MYSQL_CONNECT_FLAGS', null\\);";

    'common-config.php flags SSL':
      line  => "define('DJ_MYSQL_CONNECT_FLAGS', MYSQLI_CLIENT_SSL);",
      match => "define\\('DJ_MYSQL_CONNECT_FLAGS', MYSQLI_CLIENT_SSL\\);";
  }
}
