# Class: intelie_activemq
#
# This module manages the ActiveMQ messaging middleware.
#
# Parameters:
#
# Actions:
#
# Requires:
#
#   Class['java']
#
# Sample Usage:
#
# node default {
#   class { 'intelie_activemq': }
# }
#
# To supply your own configuration file:
#
# node default {
#   class { 'intelie_activemq':
#     server_config => template('site/activemq.xml.erb'),
#   }
# }
#
class intelie_activemq(
  $version               = 'present',
  $ensure                = 'running',
  $packagename           = 'activemq',
  $user                  = 'activemq',
  $group                 = 'activemq',
  $home_dir              = '/usr/share/activemq',
  $log_dir               = undef, #defined by underlying class unless especified
  $init_script           = undef, #defined by underlying class unless especified
  $server_config         = undef, #defined by underlying class unless especified
  $server_config_path    = undef, #defined by underlying class unless especified
  $log4j_config          = undef, #defined by underlying class unless especified
  $log4j_config_path     = undef, #defined by underlying class unless especified
  $wrapper_config_path   = undef, #defined by underlying class unless especified
  $wrapper_conf_template = undef, #defined by underlying class unless especified
  $java_initmemory       = undef, #defined by underlying class unless especified
  $java_maxmemory        = undef, #defined by underlying class unless especified
  $webconsole            = undef, #defined by underlying class unless especified
) {

  validate_re($ensure, '^running$|^stopped$')
  validate_re($version, '^present$|^latest$|^[._0-9a-zA-Z:-]+$')

  $version_real     = $version
  $ensure_real      = $ensure
  $packagename_real = $packagename

  # Anchors for containing the implementation class
  anchor { 'begin':
    before => Class['packages'],
    notify => Class['service'],
  }

  class { 'packages':
    name               => $packagename_real,
    version            => $version_real,
    home               => $home_dir,
    notify             => Class['service'],
  }

  class { 'config':
    require               => Class['packages'],
    user                  => $user,
    group                 => $group,
    init_script           => $init_script,
    server_config         => $server_config,
    server_config_path    => $server_config_path,
    log4j_config          => $log4j_config,
    log4j_config_path     => $log4j_config_path,
    wrapper_config_path   => $wrapper_config_path,
    wrapper_conf_template => $wrapper_conf_template,
    home_dir              => $home_dir,
    log_dir               => $log_dir,
    java_initmemory       => $java_initmemory,
    java_maxmemory        => $java_maxmemory,
    webconsole            => $webconsole,
    notify                => Class['service'],
  }

  class { 'service':
    ensure => $ensure_real,
  }

  anchor { 'end':
    require => Class['service'],
  }

}
