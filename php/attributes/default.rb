#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: php
# Attribute:: default
#
# Copyright 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

lib_dir = kernel['machine'] =~ /x86_64/ ? 'lib64' : 'lib'

default['php']['install_method'] = 'package'

case node["platform"]
when "debian", "ubuntu"
  default['php']['conf_dir']      = '/etc/php5/cli'
  default['php']['ext_conf_dir']  = '/etc/php5/conf.d'
  default['php']['fpm_user']      = 'www-data'
  default['php']['fpm_group']     = 'www-data'
  default['php']['fpm_service']   = 'php5-fpm'
  default['php']['uid']           = 'root'
  default['php']['gid']           = 'root'
when "openbsd"
  default['php']['conf_dir']      = '/etc/php-5.3'
  default['php']['ext_conf_dir']  = '/etc/php-5.3'
  default['php']['fpm_conf']      = '/etc/php-fpm.conf'
  default['php']['fpm_user']      = 'www'
  default['php']['fpm_group']     = 'www'
  default['php']['fpm_service']   = 'php_fpm'
  default['php']['uid']           = 'root'
  default['php']['gid']           = 'root'
  default['php']['install_method'] = nil
when "freebsd"
  default['php']['conf_dir']      = '/usr/local/etc'
  default['php']['fpm_user']      = 'www'
  default['php']['fpm_group']     = 'www'
  default['php']['fpm_service']   = 'php-fpm'
  default['php']['php5_gd_options']  = %w{
    WITH_T1LIB=true
    WITH_TRUETYPE=true
    WITH_JIS=true
  }
  default['php']['php5_options']  = %w{
    WITH_CLI=true
    WITH_CGI=true
    WITH_FPM=true
    WITHOUT_APACHE=true
    WITHOUT_AP2FILTER=true
    WITHOUT_DEBUG=true
    WITH_SUHOSIN=true
    WITH_MULTIBYTE=true
    WITH_IPV6=true
    WITHOUT_MAILHEAD=true
    WITHOUT_LINKTHR=true
  }
  default['php']['php5_mysqli_options'] = %w{
    WITH_MYSQLND=true
  }
  default['php']['php5_extensions_options']  = %w{
    WITH_BCMATH=true
    WITH_BZ2=true
    WITH_CALENDAR=true
    WITH_CTYPE=true
    WITH_CURL=true
    WITH_DBA=true
    WITH_DOM=true
    WITHOUT_EXIF=true
    WITHOUT_FILEINFO=true
    WITH_FILTER=true
    WITHOUT_FRIBIDI=true
    WITHOUT_FTP=true
    WITH_GD=true
    WITH_GETTEXT=true
    WITHOUT_GMP=true
    WITH_HASH=true
    WITH_ICONV=true
    WITHOUT_IMAP=true
    WITHOUT_INTERBASE=true
    WITH_JSON=true
    WITH_LDAP=true
    WITH_MBSTRING=true
    WITH_MCRYPT=true
    WITHOUT_MSSQL=true
    WITHOUT_MYSQL=true
    WITH_MYSQLI=true
    WITHOUT_ODBC=true
    WITH_OPENSSL=true
    WITHOUT_PCNTL=true
    WITHOUT_PDF=true
    WITH_PDO=true
    WITH_PDO_SQLITE=true
    WITH_PGSQL=true
    WITH_PHAR=true
    WITH_POSIX=true
    WITHOUT_PSPELL=true
    WITHOUT_READLINE=true
    WITHOUT_RECODE=true
    WITH_SESSION=true
    WITHOUT_SHMOP=true
    WITH_SIMPLEXML=true
    WITHOUT_SNMP=true
    WITHOUT_SOAP=true
    WITH_SOCKETS=true
    WITH_SQLITE=true
    WITH_SQLITE3=true
    WITHOUT_SYBASE_CT=true
    WITHOUT_SYSVMSG=true
    WITHOUT_SYSVSEM=true
    WITHOUT_SYSVSHM=true
    WITHOUT_TIDY=true
    WITH_TOKENIZER=true
    WITHOUT_WDDX=true
    WITH_XML=true
    WITH_XMLREADER=true
    WITHOUT_XMLRPC=true
    WITH_XMLWRITER=true
    WITHOUT_XSL=true
    WITHOUT_YAZ=true
    WITH_ZIP=true
    WITH_ZLIB=true
  }
  default['php']['uid']           = 'root'
  default['php']['gid']           = 'wheel'
else
  default['php']['conf_dir']      = '/etc/php5/cli'
  default['php']['ext_conf_dir']  = '/etc/php5/conf.d'
  default['php']['fpm_user']      = 'www-data'
  default['php']['fpm_group']     = 'www-data'
end
