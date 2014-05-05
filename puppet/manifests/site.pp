node default {
  class { 'apt'          : always_apt_update => true      }
  class { 'mysql::server': root_password     => 'vagrant' }
  include domjudge::domserver
  include domjudge::judgehost
}
