include_attribute "ntp"

default[:ntp][:server][:servers] = %w{
  ntp.nict.jp
  ntp.jst.mfeed.ad.jp
}
