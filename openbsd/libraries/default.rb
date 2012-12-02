def get_loopback(conf)
    conf.select { |nic| nic =~ /^lo/ }.first
end

def get_gre(conf)
    conf.select { |nic| nic =~ /^gre/ }.first
end

def get_enc(conf)
    conf.select { |nic| nic =~ /^enc/ }.first
end
