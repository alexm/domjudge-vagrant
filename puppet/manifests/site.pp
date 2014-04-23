class { 'apt': always_apt_update => true }

apt::source { 'domjudge':
  location          => 'http://non-gnu.uvt.nl/debian',
  release           => 'squeeze',
  repos             => 'uvt',
  key               => '211A1230',
  key_server        => 'pgp.mit.edu',
}

package {
  'domjudge-domserver':
    ensure  => present,
    require => Apt::Source['domjudge']
}

file {
  '/etc/apache2/conf.d/domjudge':
    ensure  => link,
    target  => '/etc/domjudge/apache.conf',
    require => Package['domjudge-domserver']
}
