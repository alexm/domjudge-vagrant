class domjudge::domserver inherits domjudge {
  include mysql::server

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
}
