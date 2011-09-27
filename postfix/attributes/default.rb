default[:postfix][:config][:dir] = "/etc/postfix"
default[:postfix][:config][:aliases] = "/etc/aliases"

# ロールで上書きする
default[:postfix][:config][:myorigin] = hostname
default[:postfix][:config][:admin] = "root@#{domain}"
