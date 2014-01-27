class apachewrapper::params ()
{   
   $vhosts = hiera ("apachewrapper::params::vhosts", 
 { 'accelerators.org.uk'=> {
      vhost_name => '*',
      port       => '80',
      serveradmin => "n.delerue1@physics.ox.ac.uk",
      docroot          => '/home/adams/public_html/everywhere',
      serveraliases    => ['www.accelerators.org.uk',"www.accelerators.physics.ox.ac.uk"],
      access_log_file => "acceleratorsorg-new-access_log",
      error_log_file => "acceleratorsorg-new-access_log",
      docroot_owner               => 'adams',
      docroot_group               => "lc",
      logroot => "/var/log/httpd",
   } } )
 
}
