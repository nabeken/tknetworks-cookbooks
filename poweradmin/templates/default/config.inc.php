<?php

$db_host                = '<%= node[:pdns][:db_host] %>';
$db_user                = '<%= node[:pdns][:db_user] %>';
$db_pass                = '<%= node[:pdns][:db_password] %>';
$db_name                = '<%= node[:pdns][:db_name] %>';
$db_port                = '5432';
$db_type                = 'pgsql';

$iface_lang             = 'en_EN';

$dns_hostmaster         = '<%= node[:poweradmin][:dns_hostmaster] %>';
$dns_ns1                = '<%= node[:poweradmin][:dns_ns1] %>';
$dns_ns2                = '<%= node[:poweradmin][:dns_ns2] %>';
?>
