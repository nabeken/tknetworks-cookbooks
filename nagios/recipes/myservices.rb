nagios_generic "generic-service" do
    generic_type "service"
    config ({
        :active_checks_enabled        => 1,
        :passive_checks_enabled       => 1,
        :parallelize_check            => 1,
        :obsess_over_service          => 1,
        :check_freshness              => 0,
        :notifications_enabled        => 1,
        :event_handler_enabled        => 1,
        :flap_detection_enabled       => 1,
        :process_perf_data            => 1,
        :retain_status_information    => 1,
        :retain_nonstatus_information => 1,
        :notification_period          => "24x7",
        :check_period                 => "24x7",
        :notification_options         => "w,u,c,r,f",
        :is_volatile                  => 0,
        :contact_groups               => node.nagios.server.contact_groups,
        :max_check_attempts           => 3,
        :retry_check_interval         => 1,
        :normal_check_interval        => 3,
        :notification_interval        => 120
    })
end

# nagios_service "example" do
#     use         "generic-service"
#     host        "www.example.org"
#     description "example service"
#     command     "check_example"
# end
