define logship::manage (
  $data_collector,
  $destination,
  $log_path,
  $ensure               = 'present',
  $config_file_name     = '',
  $fluentd_type         = undef,
  $fluentd_format       = undef,
  $fluentd_match_config = undef,
  $aws_key_id           = undef,
  $aws_sec_key          = undef,
  $s3_bucket            = undef,
  $s3_endpoint          = undef,
  $s3_path              = undef,
) {

  include logship::params

  if !($data_collector in $logship::params::data_collectors) {
    fail("data_collector '$data_collector' is not actually supported")
  }

  if !($destination in $logship::params::destinations[$data_collector]) {
    fail("destination '$destination' is not actually supported for data_collector '$data_collector'")
  }

  $config_file = $config_file_name? {
    ''      => $name,
    default => $config_file_name
  }

  case $data_collector {
    'fluentd':  {
      include fluentd
      
      $input_configs = {
        'path'      => $fluentd_path,
        'pos_file'  => "${fluentd_pos_dir}${name}_fluentd.pos",
      }
	
      fluentd::configfile {$config_file:}
      fluentd::source{ "${name}_source":
        configfile  => $config_file,
        type        => $fluentd_type,
        format      => $fluentd_format,
        tag         => "${destination}.${name}.log",
        config      => $input_configs,
        notify      => Class['fluentd::service']
      }

      case $destination {
        's3': {
          $destination_config = {
            'aws_key_id'  => $aws_key_id,
            'aws_sec_key' => $aws_sec_key,
            's3_bucket'   => $s3_bucket,
            's3_endpoint' => $s3_endpoint,
            'path'        => $s3_path,
          }
        }
        default: {
          $destination_config = {}
        }
      }
      $output_config = merge($fluentd_math_config, $destination_config)

      fluentd::match{ "${name}_match":
        configfile  => $config_file,
        config      => $output_config,
        type        => $destination,
        pattern     => "${destination}.${name}.*",
      }
    }  
  }
}
