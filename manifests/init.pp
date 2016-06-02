#This define will export the required proxy configuration to puppetdb
#If you dont have a reverseproxy in place to collect it, it doesnt really hurt
#If you do have one, and you dont point your CNAME or alaiases at the proxy, then
#Its not going to do anything either!
#This info is collected by any and all servers including the apachewrapper::webproxy module
define webproxyclient ( $vhosts ) 
{
 if $::osfamily == Redhat {
     $httpconffile = "/etc/httpd/conf.d/${name}_on_${hostname}_proxy.conf"
     }
 else {
     $httpconffile = "/etc/apache2/sites-enabled/${name}_on_${hostname}_proxy.conf"
 }

 if (has_key($vhosts["$name"], 'ssl') ) and ( str2bool("${vhosts[$name]['ssl']}") == true ) {
   $httptech="https"
   $sslengine = "on"
   $sslproxyengine = "on"
#TODO For SSl hosts, we also need to extract the following from the hash
#    SSLCertificateFile      "/etc/httpd/SSL/xray/xray.physics.ox.ac.uk.crt"
#    SSLCertificateKeyFile   "/etc/httpd/SSL/xray/xray.key"
#    SSLCertificateChainFile "/etc/httpd/SSL/xray/s2cabundle.pem"
#    SSLCACertificatePath    "/etc/pki/tls/certs"

 }
 else {
   $httptech = "http" 
   $sslengine = "off"
   $sslproxyengine = "off"

 }

 
  @@file  { "$httpconffile":
           content => "<VirtualHost *:${vhosts[$name][port]}>
    ProxyPreserveHost On
    SSLEngine $sslengine
    SSLProxyEngine $sslproxyengine

    # Servers to proxy the connection, or;
    # List of application servers:
    # Usage:
    # ProxyPass / http://[IP Addr.]:[port]/
    # ProxyPassReverse / http://[IP Addr.]:[port]/
    # Example: 
    ProxyPass / ${httptech}://${ipaddress}:${vhosts[$name][port]}/
    ProxyPassReverse / ${httptech}://${ipaddress}:${vhosts[$name][port]}/
 
    ServerName ${vhosts[$name][servername]}
</VirtualHost>",
           tag => proxyconfigs,
#Not in the catalog
#           notify => Service['httpd']
  }

}
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
  $keys = keys($vhosts)
  webproxyclient{ $keys: vhosts => $vhosts }
}



