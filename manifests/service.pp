# == Class logship::service
#
# This class is meant to be called from logship
# It ensure the service is running
#
class logship::service {

  service { $logship::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
