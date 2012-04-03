maintainer        "Ken-ichi TANABE"
maintainer_email  "nabeken@tknetworks.org"
license           "Apache 2.0"
description       "Installs and configures postgresql for clients or servers"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.99.3"
recipe            "postgresql", "Includes postgresql::client"
recipe            "postgresql::client", "Installs postgresql client package(s)"
recipe            "postgresql::server", "Installs postgresql server packages, templates"

%w{debian freebsd}.each do |os|
  supports os
end

depends "openssl"
depends "debian"
