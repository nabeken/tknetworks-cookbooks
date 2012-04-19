default[:poweradmin][:git_repository] = "git://github.com/poweradmin/poweradmin.git"
default[:poweradmin][:version] = "v2.1.5"

case platform
when "freebsd"
  default[:poweradmin][:packages] = %w{
    databases/pear-MDB2_Driver_pgsql
  }
  default[:poweradmin][:install_dir] = "/usr/local/www/poweradmin"
when "debian"
  default[:poweradmin][:packages] = %w{
    php-mdb2-driver-pgsql
    php5-mcrypt
  }
  default[:poweradmin][:install_dir] = "/var/www/poweradmin"
end
