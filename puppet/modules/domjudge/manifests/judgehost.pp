class domjudge::judgehost inherits domjudge {
  package {
    'cgroup-lite':
      ensure => present;

    'domjudge-judgehost':
      ensure  => present,
      require => Package['cgroup-lite'];
  }
}
