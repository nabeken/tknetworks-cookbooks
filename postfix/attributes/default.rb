default[:postfix][:config][:aliases] = "/etc/aliases"

# ロールで上書きする
default[:postfix][:config][:myorigin] = domain
default[:postfix][:config][:admin] = "root@#{domain}"

case platform
when "freebsd"
  default[:postfix][:newaliases]   = "/usr/local/bin/newaliases"
  default[:postfix][:config][:dir] = "/usr/local/etc/postfix"
else
  default[:postfix][:newaliases]   = "/usr/bin/newaliases"
  default[:postfix][:config][:dir] = "/etc/postfix"
end
