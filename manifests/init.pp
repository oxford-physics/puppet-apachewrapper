class apachewrapper ($vhosts = $apachewrapper::params::vhosts )  
inherits apachewrapper::params 
{
#   class { 'apache':
#      default_mods        => false,
#      default_confd_files => false,
#    }

include 'apache'
      
  $vhost_defaults= {}
  create_resources(apache::vhost, $vhosts,$vhost_defaults)

  

}

