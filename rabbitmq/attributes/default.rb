case platform
when "freebsd"
  default[:rabbitmq][:package] = "net/rabbitmq"
  default[:rabbitmq][:service] = "rabbitmq"
end
