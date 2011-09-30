unless nagios.attribute?("service")
  default[:nagios][:service] = Mash.new
end
