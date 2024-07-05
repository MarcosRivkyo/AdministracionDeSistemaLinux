#!/usr/bin/perl

use strict;
use warnings;
use IO::Socket::INET;

use CGI;

my $cgi = CGI->new;

print $cgi->header;



sub check_port {
    my ($host, $port) = @_;

    
    if ($port < 1 || $port > 65535) {
        return "Número de puerto inválido";
    }

    
    my $socket = IO::Socket::INET->new(
        PeerAddr => $host,
        PeerPort => $port,
        Proto    => 'tcp',
        Timeout  => 2
    );

   
    if ($socket) {
        close $socket;
        return 1;  # Servicio Abierto
    } else {
        return 0;  # Servicio Cerrado
    }
}



my %services = (
    'HTTP'  => 80,
    'HTTPS' => 443,
    'SFTP'  => 22,  
    'SMTP'  => 25,
    'SSH'   => 22,
    'Proxy' => 8080, 
    'DB'    => 3306  
);


my $host = "192.168.1.85";


my %results;


foreach my $service (keys %services) {
    my $port = $services{$service};
    my $result = check_port($host, $port);
    $results{$service} = $result;
}






print "<!DOCTYPE html>\n";
print "<html>\n";
print "<head>\n";
print "    <title>Estado de los servicios</title>\n";
print "    <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css\">\n";
print "    <style>\n";
print "        body {\n";
print "            font-family: Arial, sans-serif;\n";
print "            background-color: #57E17F; /* Fondo verde */\n";
print "            margin: 0;\n";
print "            padding: 0;\n";
print "        }\n";
print "\n";
print "        h1 {\n";
print "            text-align: center;\n";
print "            color: #333;\n";
print "        }\n";
print "\n";
print "        table {\n";
print "            width: 50%;\n";
print "            margin: 20px auto;\n";
print "            border-collapse: collapse;\n";
print "            background-color: #fff;\n";
print "            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);\n";
print "        }\n";
print "\n";
print "        th, td {\n";
print "            border: 1px solid #ddd;\n";
print "            padding: 10px;\n";
print "            text-align: center;\n";
print "        }\n";
print "\n";
print "        th {\n";
print "            background-color: #f2f2f2;\n";
print "        }\n";
print "\n";
print "        .open {\n";
print "            color: green;\n";
print "        }\n";
print "\n";
print "        .closed {\n";
print "            color: red;\n";
print "        }\n";
print "    </style>\n";
print "</head>\n";
print "<body>\n";
print "    <h1>Estado de los servicios en DIA-server</h1>\n";
print "    <table>\n";
print "        <tr>\n";
print "            <th>Servicio</th>\n";
print "            <th>Estado</th>\n";
print "        </tr>\n";
foreach my $service (keys %results) {
    my $status = $results{$service} ? "Abierto" : "Cerrado";
    my $color = $results{$service} ? "green" : "red";
    print "        <tr>\n";
    print "            <td>$service</td>\n";
    print "            <td style=\"color:$color\">\n";
    print "                $status\n";
    if ($results{$service}) {
        print "                <i class=\"fas fa-check-circle open\"></i>\n";
    } else {
        print "                <i class=\"fas fa-times-circle closed\"></i>\n";
    }
    print "            </td>\n";
    print "        </tr>\n";
}
print "    </table>\n";
print "</body>\n";
print "</html>\n";
