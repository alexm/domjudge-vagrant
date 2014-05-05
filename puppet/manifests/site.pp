node default {
  class { 'apt': always_apt_update => true }
  include domjudge::domserver
  include domjudge::judgehost
}
