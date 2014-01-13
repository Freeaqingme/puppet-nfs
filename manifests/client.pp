# = Class: nfs::client
#
# This is the nfs::client
#
class nfs::client (
  $template_idmap     = 'nfs/idmapd.conf.erb',
  $firewall           = params_lookup('firewall', 'global' ),
  $firewall_remote    = '',
  $firewall_interface = ''
) {

  require nfs

  package { $nfs::package:
    ensure  => $nfs::manage_package,
    noop    => $nfs::noops,
  }
  
  file { '/etc/idmapd.conf':
    ensure  => present,
    mode    => 0644,
    owner   => root,
    group   => root,
    content => template($template_idmap)
  }

  if any2bool($firewall) {
    firewall::rule { 'nfs-client-rpc-udp-in':
      protocol     => udp,
      port         => 111,
      direction    => 'input',
      source       => $firewall_remote,
      in_interface => $firewall_interface,
    }

    firewall::rule { 'nfs-client-rpc-udp-out':
      protocol      => udp,
      port          => 111,
      direction     => 'output',
      destination   => $firewall_remote,
      out_interface => $firewall_interface,
    }

    firewall::rule { 'nfs-client-rpc-tcp-in':
      protocol     => tcp,
      port         => 111,
      direction    => 'input',
      source       => $firewall_remote,
      in_interface => $firewall_interface,
    }

    firewall::rule { 'nfs-client-rpc-tcp-out':
      protocol      => tcp,
      port          => 111,
      direction     => 'output',
      destination   => $firewall_remote,
      out_interface => $firewall_interface,
    }

    firewall::rule { 'nfs-client-nfs-tcp-in':
      protocol     => tcp,
      port         => 2049,
      direction    => 'input',
      destination  => $firewall_remote,
      in_interface => $firewall_interface,
    }

    firewall::rule { 'nfs-client-nfs-tcp-out':
      protocol      => tcp,
      port          => 2049,
      direction     => 'output',
      destination   => $firewall_remote,
      out_interface => $firewall_interface,
    }
  }

}
