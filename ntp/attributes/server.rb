include_attribute "ntp"

default[:ntp][:servers] = %w{
  ntp.nict.jp
  ntp.jst.mfeed.ad.jp
}
