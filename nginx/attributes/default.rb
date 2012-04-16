#
# Cookbook Name:: nginx
# Attributes:: default
#
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Ken-ichi TANABE (<nabeken@tknetworks.org>)
#
# Copyright 2009-2011, Opscode, Inc.
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

case platform
when "debian","ubuntu"
  default[:nginx][:package]    = "nginx"
  default[:nginx][:dir]        = "/etc/nginx"
  default[:nginx][:log_dir]    = "/var/log/nginx"
  default[:nginx][:user]       = "www-data"
  default[:nginx][:gid]        = "root"
  default[:nginx][:binary]     = "/usr/sbin/nginx"
  default[:nginx][:init_style] = "runit"
  default[:nginx][:nxensite]   = "/usr/sbin/nxensite"
  default[:nginx][:nxdissite]  = "/usr/sbin/nxdissite"
  default[:nginx][:fastcgi_params] = "/etc/nginx/fastcgi_params"
  default[:nginx][:fastcgi_pass] = "127.0.0.1:9000"
  default[:nginx][:worker_processes] = cpu[:total]
  default[:nginx][:location][:root_dir] = "/var/www/nginx-default"
  default[:nginx][:passenger_root] = "/usr/lib/phusion-passenger"
when "freebsd"
  default[:nginx][:package]    = "www/nginx"
  default[:nginx][:dir]        = "/usr/local/etc/nginx"
  default[:nginx][:log_dir]    = "/var/log/nginx"
  default[:nginx][:user]       = "nobody"
  default[:nginx][:gid]        = "wheel"
  default[:nginx][:binary]     = "/usr/local/sbin/nginx"
  default[:nginx][:nxensite]   = "/usr/local/sbin/nxensite"
  default[:nginx][:nxdissite]  = "/usr/local/sbin/nxdissite"
  default[:nginx][:fastcgi_params] = "/usr/local/etc/nginx/fastcgi_params"
  default[:nginx][:fastcgi_pass] = "127.0.0.1:9000"
  default[:nginx][:worker_processes] = (virtualization[:system] == "jail" and
                                        virtualization[:role] == "guest") ? 1 : cpu[:total]
  default[:nginx][:location][:root_dir] = "/var/www/nginx-default"
  default[:nginx][:ports_conf] = "/var/db/ports/nginx/options"
  default[:nginx][:options] = %w{
WITHOUT_DEBUG=true
WITHOUT_DEBUGLOG=true
WITH_FILE_AIO=true
WITH_IPV6=true
WITHOUT_GOOGLE_PERFTOOLS=true
WITH_HTTP_MODULE=true
WITH_HTTP_ADDITION_MODULE=true
WITH_HTTP_CACHE_MODULE=true
WITHOUT_HTTP_DAV_MODULE=true
WITHOUT_HTTP_FLV_MODULE=true
WITHOUT_HTTP_GEOIP_MODULE=true
WITH_HTTP_GZIP_STATIC_MODULE=true
WITHOUT_HTTP_IMAGE_FILTER_MODULE=true
WITHOUT_HTTP_MP4_MODULE=true
WITHOUT_HTTP_PERL_MODULE=true
WITHOUT_HTTP_RANDOM_INDEX_MODULE=true
WITHOUT_HTTP_REALIP_MODULE=true
WITH_HTTP_REWRITE_MODULE=true
WITHOUT_HTTP_SECURE_LINK_MODULE=true
WITH_HTTP_SSL_MODULE=true
WITH_HTTP_STATUS_MODULE=true
WITHOUT_HTTP_SUB_MODULE=true
WITHOUT_HTTP_XSLT_MODULE=true
WITHOUT_MAIL_MODULE=true
WITHOUT_MAIL_IMAP_MODULE=true
WITHOUT_MAIL_POP3_MODULE=true
WITHOUT_MAIL_SMTP_MODULE=true
WITHOUT_MAIL_SSL_MODULE=true
WITH_WWW=true
WITHOUT_CACHE_PURGE_MODULE=true
WITHOUT_ECHO_MODULE=true
WITHOUT_HEADERS_MORE_MODULE=true
WITHOUT_HTTP_ACCEPT_LANGUAGE=true
WITHOUT_HTTP_ACCESSKEY_MODULE=true
WITHOUT_HTTP_AUTH_PAM_MODULE=true
WITHOUT_HTTP_AUTH_REQ_MODULE=true
WITHOUT_HTTP_EVAL_MODULE=true
WITHOUT_HTTP_FANCYINDEX_MODULE=true
WITHOUT_HTTP_GUNZIP_FILTER=true
WITHOUT_HTTP_MOGILEFS_MODULE=true
WITH_HTTP_MP4_H264_MODULE=true
WITHOUT_HTTP_NOTICE_MODULE=true
WITHOUT_HTTP_PUSH_MODULE=true
WITHOUT_HTTP_REDIS_MODULE=true
WITHOUT_HTTP_RESPONSE_MODULE=true
WITHOUT_HTTP_SUBS_FILTER_MODULE=true
WITHOUT_HTTP_UPLOAD_MODULE=true
WITHOUT_HTTP_UPLOAD_PROGRESS=true
WITHOUT_HTTP_UPSTREAM_FAIR=true
WITHOUT_HTTP_UPSTREAM_HASH=true
WITHOUT_HTTP_UPSTREAM_KEEPALIVE=true
WITHOUT_HTTP_ZIP_MODULE=true
WITHOUT_CHUNKIN_MODULE=true
WITHOUT_DRIZZLE_MODULE=true
WITHOUT_GRIDFS_MODULE=true
WITHOUT_LUA_MODULE=true
WITHOUT_MEMC_MODULE=true
WITHOUT_NAXSI_MODULE=true
WITH_PASSENGER_MODULE=true
WITHOUT_POSTGRES_MODULE=true
WITHOUT_RDS_CSV_MODULE=true
WITHOUT_RDS_JSON_MODULE=true
WITHOUT_REDIS2_MODULE=true
WITHOUT_SET_MISC_MODULE=true
WITHOUT_SLOWFS_CACHE_MODULE=true
WITHOUT_SRCACHE_MODULE=true
WITHOUT_SUPERVISORD_MODULE=true
WITHOUT_SYSLOG_SUPPORT=true
WITHOUT_UDPLOG_MODULE=true
WITHOUT_XRID_HEADER_MODULE=true
WITHOUT_XSS_MODULE=true
}
else
  default[:nginx][:package]    = "nginx"
  default[:nginx][:dir]        = "/etc/nginx"
  default[:nginx][:log_dir]    = "/var/log/nginx"
  default[:nginx][:user]       = "www-data"
  default[:nginx][:binary]     = "/usr/sbin/nginx"
  default[:nginx][:init_style] = "init"
  default[:nginx][:nxensite]   = "/usr/sbin/nxensite"
  default[:nginx][:nxdissite]  = "/usr/sbin/nxdissite"
  default[:nginx][:location][:root_dir] = "/var/www/nginx-default"
  default[:nginx][:passenger_root] = proc { `passenger-config --root || :`.strip }
end

default[:nginx][:gzip] = "on"
default[:nginx][:gzip_http_version] = "1.0"
default[:nginx][:gzip_comp_level] = "2"
default[:nginx][:gzip_proxied] = "any"
default[:nginx][:gzip_types] = [
  "text/plain",
  "text/html",
  "text/css",
  "application/x-javascript",
  "text/xml",
  "application/xml",
  "application/xml+rss",
  "text/javascript"
]

default[:nginx][:keepalive]          = "on"
default[:nginx][:passenger]          = "on"
default[:nginx][:keepalive_timeout]  = 65
default[:nginx][:worker_connections] = 2048
default[:nginx][:server_names_hash_bucket_size] = 64

default[:nginx][:disable_access_log] = false
