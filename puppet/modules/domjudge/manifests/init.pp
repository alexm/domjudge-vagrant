class domjudge {
  include apt

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
}
