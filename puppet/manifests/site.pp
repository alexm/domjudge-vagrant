class { 'apt': always_apt_update => true }

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

package {
  'domjudge-domserver':
    ensure => present;

  'cgroup-lite':
    ensure => present;

  'domjudge-judgehost':
    ensure  => present,
    require => Package['cgroup-lite']
}

file {
  '/etc/apache2/conf.d/domjudge':
    ensure  => link,
    target  => '/etc/domjudge/apache.conf',
    require => Package['domjudge-domserver']
}
