# = Class: nfs::client
#
# This is the nfs::client
#
class nfs::client (
  $template_idmap = 'nfs/idmapd.conf.erb'
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

}
