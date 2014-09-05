# == Class logship::install
#
class logship::install {

  package { $logship::package_name:
    ensure => present,
  }
}
