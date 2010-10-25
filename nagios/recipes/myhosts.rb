# Examples
nagios_generic "generic-server" do
    generic_type "host"
    config ({
        :notifications_enabled        => 1,
        :event_handler_enabled        => 1,
        :flap_detection_enabled       => 1,
        :process_perf_data            => 1,
        :retain_status_information    => 1,
        :retain_nonstatus_information => 1,
        :notification_interval        => 120,
        :notification_period          => "24x7",
        :notification_options         => "d,u,r,f",
        :check_command                => "check-host-alive",
        :max_check_attempts           => 3
    })
end

nagios_generic "generic-router" do
    generic_type "host"
    config ({
        :notifications_enabled        => 1,
        :event_handler_enabled        => 1,
        :flap_detection_enabled       => 1,
        :process_perf_data            => 1,
        :retain_status_information    => 1,
        :retain_nonstatus_information => 1,
        :notification_interval        => 120,
        :notification_period          => "24x7",
        :notification_options         => "d,u,r,f",
        :check_command                => "check-host-alive",
        :max_check_attempts           => 3
    })
end

# nagios_host "www.example.org" do
#     use "generic-server"
#     host_alias "example host"
#     address "10,0.0.1"
# end
