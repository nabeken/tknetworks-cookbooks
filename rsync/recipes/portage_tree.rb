rsync_module "gentoo-portage" do
  path     node.rsync.server.portage.path
  comment  "Gentoo Portage Tree"
  readonly true
  allow    node.rsync.server.portage.allow
  deny     node.rsync.server.portage.deny
end
