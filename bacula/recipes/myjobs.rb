#
# example
#
# jobs = {
#     "bacula-fd.example.org" => {
#         :default  => "Example",
#         :schedule => "ExampleSchedule",
#         :storage  => "ExampleStorage"
#     },
# }
# 
# jobs.each do |name, config|
#     bacula_job name do
#         default  config[:default]
#         schedule config[:schedule]
#         storage  config[:storage]
#     end
# end
