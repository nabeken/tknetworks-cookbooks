include_attribute "nginx"
inclute_attribute "poweradmin"

# must be set via role
default[:poweradmin][:vhost] = "localhost"
