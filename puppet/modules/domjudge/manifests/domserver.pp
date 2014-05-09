class domjudge::domserver($dbpass,$dbserver) inherits domjudge {
  include stdlib

  package {
    'domjudge-domserver':
      ensure  => present;
  }

  file {
    '/etc/apache2/conf.d/domjudge':
      ensure  => link,
      target  => '/etc/domjudge/apache.conf',
      require => Package['domjudge-domserver'],
      notify  => Service['apache2'];
  }

  File_line {
    path    => '/etc/domjudge/domserver.dbconfig.php',
    require => Package['domjudge-domserver'],
  }

  file_line {
    'domserver.dbconfig.php pass':
      line  => "\$dbpass='$dbpass';",
      match => '^\$dbpass=.*';

    'domserver.dbconfig.php server':
      line  => "\$dbserver='$dbserver';",
      match => '^\$dbserver=.*';
  }

  service { 'apache2': }
}
