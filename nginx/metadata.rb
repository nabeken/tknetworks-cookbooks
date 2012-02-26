maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures nginx"
version           "0.99.3"

recipe "nginx", "Installs nginx package and sets up configuration with Debian apache style with sites-enabled/sites-available"
recipe "nginx::source", "Installs nginx from source and sets up configuration with Debian apache style with sites-enabled/sites-available"

%w{ubuntu debian freebsd}.each do |os|
  supports os
end

depends "freebsd"
depends "php"

attribute "nginx/dir",
  :display_name => "Nginx Directory",
  :description  => "Location of nginx configuration files",
  :default      => "/etc/nginx"

attribute "nginx/log_dir",
  :display_name => "Nginx Log Directory",
  :description  => "Location for nginx logs",
  :default      => "/var/log/nginx"

attribute "nginx/user",
  :display_name => "Nginx User",
  :description  => "User nginx will run as",
  :default      => "www-data"

attribute "nginx/binary",
  :display_name => "Nginx Binary",
  :description  => "Location of the nginx server binary",
  :default      => "/usr/sbin/nginx"

attribute "nginx/nxensite",
  :display_name => "Nginx ensite script",
  :description  => "Location of the nginx ensite script",
  :default      => "/usr/sbin/nxensite"

attribute "nginx/nxdissite",
  :display_name => "Nginx dissite script",
  :description  => "Location of the nginx dissite script",
  :default      => "/usr/sbin/nxdissite"

attribute "nginx/location/root_dir",
  :display_name => "Nginx Root Directory",
  :description  => "Location for the nginx root directory",
  :default      => "/var/www/nginx-default"

attribute "nginx/package",
  :display_name => "Nginx Package Name",
  :description  => "the nginx as package name",
  :default      => "nginx"

attribute "nginx/options",
  :display_name => "Nginx Ports Options",
  :description  => "ports options for www/nginx (only for FreeBSD)",
  :default      => "See attributes/default.rb"

attribute "nginx/gzip",
  :display_name => "Nginx Gzip",
  :description  => "Whether gzip is enabled",
  :default      => "on"

attribute "nginx/gzip_http_version",
  :display_name => "Nginx Gzip HTTP Version",
  :description  => "Version of HTTP Gzip",
  :default      => "1.0"

attribute "nginx/gzip_comp_level",
  :display_name => "Nginx Gzip Compression Level",
  :description  => "Amount of compression to use",
  :default      => "2"

attribute "nginx/gzip_proxied",
  :display_name => "Nginx Gzip Proxied",
  :description  => "Whether gzip is proxied",
  :default      => "any"

attribute "nginx/gzip_types",
  :display_name => "Nginx Gzip Types",
  :description  => "Supported MIME-types for gzip",
  :type         => "array",
  :default      => [ "text/plain", "text/html", "text/css", "application/x-javascript", "text/xml", "application/xml", "application/xml+rss", "text/javascript" ]

attribute "nginx/keepalive",
  :display_name => "Nginx Keepalive",
  :description  => "Whether to enable keepalive",
  :default      => "on"

attribute "nginx/keepalive_timeout",
  :display_name => "Nginx Keepalive Timeout",
  :default      => "65"

attribute "nginx/worker_processes",
  :display_name => "Nginx Worker Processes",
  :description  => "Number of worker processes",
  :default      => "1"

attribute "nginx/worker_connections",
  :display_name => "Nginx Worker Connections",
  :description  => "Number of connections per worker",
  :default      => "1024"

attribute "nginx/server_names_hash_bucket_size",
  :display_name => "Nginx Server Names Hash Bucket Size",
  :default      => "64"

attribute "nginx/disable_access_log",
  :display_name => "Disable Access Log",
  :default      => "false"
