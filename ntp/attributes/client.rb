include_attribute "ntp"

default[:ntp][:servers] = [
  "0.#{platform}.pool.ntp.org",
  "1.#{platform}.pool.ntp.org",
]
