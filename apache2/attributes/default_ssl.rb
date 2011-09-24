include_attribute "apache2"

default[:apache2][:config][:cert] = "/etc/ssl/certs/ssl-cert-snakeoil.pem"
default[:apache2][:config][:cert_key] = "/etc/ssl/private/ssl-cert-snakeoil.key"
default[:apache2][:default_ssl_only] = false
