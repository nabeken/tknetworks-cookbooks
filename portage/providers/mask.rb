# maskは1パッケージに複数と仮定
# 最近はどうも/etc/portage/package.mask/PKG-NAMEみたいな書き方ができるようだ

include Chef::PortageResource::MaskUnmask

def initialize(*args)
  super(*args)
  @element = :mask
end

def load_current_resource
  _load_current_resource
end
