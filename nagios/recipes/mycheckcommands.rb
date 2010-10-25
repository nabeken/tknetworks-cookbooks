# Examples
check_commands = {
    "check_ping" =>
        '$USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -p 5',
    "check_ping6" =>
        '$USER1$/check_ping -6 -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -p 5',
    "check_tcp" =>
        '$USER1$/check_tcp -H $HOSTADDRESS$ -p $ARG1$',
    "check-host-alive" =>
        '$USER1$/check_ping -H $HOSTADDRESS$ -w 3000.0,80% -c 5000.0,100% -p 1'
}

check_commands.each do |name, cmd|
    nagios_checkcommand name do
        command_line cmd
    end
end
