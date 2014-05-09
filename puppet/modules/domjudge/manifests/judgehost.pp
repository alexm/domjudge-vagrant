class domjudge::judgehost($dbpass,$dbserver) inherits domjudge {
  include stdlib

  package {
    'cgroup-lite':
      ensure => present;

    'domjudge-judgehost':
      ensure  => present,
      require => Package['cgroup-lite'];
  }

  service { 'domjudge-judgehost': }

  File_line {
    path    => '/etc/domjudge/judgedaemon.dbconfig.php',
    require => Package['domjudge-judgehost'],
    notify  => Service['domjudge-judgehost'],
  }

  file_line {
    'judgedaemon.dbconfig.php pass':
      line   => "\$dbpass='$dbpass';",
      match  => '^\$dbpass=.*';

    'judgedaemon.dbconfig.php server':
      line  => "\$dbserver='$dbserver';",
      match => '^\$dbserver=.*';
  }
}
