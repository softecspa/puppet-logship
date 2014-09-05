# == Class logship::params
#
# This class is meant to be called from logship
# It sets variables according to platform
#
class logship::params {

  $data_collectors = [ 'fluentd' ]
  $destinations = {
    'fluentd'  => [ 's3' ]
  }
}
