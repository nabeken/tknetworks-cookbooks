# 
# example
#
# devices = {
#     "ExapleStorage" => {
#         :device => "/srv/bacula/example"
#     },
# }
# 
# devices.each do |name, config|
#     bacula_sd_device name do
#         device config[:device]
#     end
# end
