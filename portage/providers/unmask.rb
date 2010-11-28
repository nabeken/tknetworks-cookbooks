# unmaskは1パッケージに複数と仮定
# 最近はどうも/etc/portage/package.unmask/PKG-NAMEみたいな書き方ができるようだ

include Chef::PortageResource::MaskUnmask

def initialize(*args)
  super(*args)
  @element = :unmask
end

def load_current_resource
  _load_current_resource
end
