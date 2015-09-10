class apachewrapper::params ()
{   
   $vhosts = hiera ("apachewrapper::params::vhosts", 
    { 'default' =>
      {  
       vhost_name  => '*',
       port        => '80',
       serveradmin => "webmaster@physics.ox.ac.uk",
       docroot     => '/var/www/html',
       docroot_owner       => root,
       logroot     => "/var/log/httpd",
      }
    } )
 
} 
