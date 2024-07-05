#!/usr/bin/perl

use strict;
use warnings;
use File::ReadBackwards;
use CGI;

my $cgi = CGI->new;

print $cgi->header;

sub get_cpu_load {
    my $mpstat_output = `mpstat | tail -n 1`;

    my ($cpu_user, $cpu_nice, $cpu_sys, $cpu_iowait, $cpu_irq, $cpu_softirq, $cpu_steal, $cpu_guest, $cpu_gnice, $cpu_idle) =
        ($mpstat_output =~ /all\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)/);

    return ($cpu_user, $cpu_nice, $cpu_sys, $cpu_iowait, $cpu_irq, $cpu_softirq, $cpu_steal, $cpu_guest, $cpu_gnice, $cpu_idle);
}

sub get_memory_usage {
    my $memory_usage = `sudo /usr/bin/free -m | grep Mem`;
    my ($total_mem, $used_mem, $free_mem) = ($memory_usage =~ /Mem:\s+(\d+)\s+(\d+)\s+(\d+)/);
    return ($total_mem, $used_mem, $free_mem);
}

sub get_disk_usage {
    my $disk_usage = `df -h / | tail -n 1`;

    my ($total_disk, $used_disk, $free_disk, $porcentaje) = ($disk_usage =~ /(\d+(?:[.,]\d+)?)[GMK]? +(\d+(?:[.,]\d+)?)[GMK]? +(\d+(?:[.,]\d+)?)[GMK]? +(\d+)%/);
    return ($total_disk, $used_disk, $free_disk, $porcentaje);
}

# Carga de la CPU
my ($user, $nice, $sys, $iowait, $irq, $softirq, $steal, $guest, $gnice, $idle) = get_cpu_load();

# Uso de memoria
my ($total_mem, $used_mem, $free_mem) = get_memory_usage();

# Uso de disco 
my ($total_disk, $used_disk, $free_disk, $porcentaje) = get_disk_usage();


# Mostrar la información en formato HTML

print "<!DOCTYPE html>\n";
print "<html>\n";
print "<head>\n";
print "    <title>Estado del Sistema</title>\n";
print "    <style>\n";
print "        body {\n";
print "            font-family: Arial, sans-serif;\n";
print "            background-color:  #57E17F;\n";
print "            margin: 0;\n";
print "            padding: 0;\n";
print "            display: flex;\n";
print "            justify-content: center;\n";
print "            align-items: center;\n";
print "            height: 100vh;\n";
print "        }\n";
print "        .container {\n";
print "            width: 80%;\n";
print "            max-width: 800px;\n";
print "            background-color: #fff;\n";
print "            padding: 20px;\n";
print "            border-radius: 10px;\n";
print "            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);\n";
print "        }\n";
print "        h1 {\n";
print "            text-align: center;\n";
print "            margin-bottom: 20px;\n";

print "            color: #333;\n";
print "        }\n";
print "        h2 {\n";
print "            color: #555;\n";
print "        }\n";
print "        p {\n";
print "            color: #777;\n";
print "        }\n";
print "        pre {\n";
print "            background-color: #f5f5f5;\n";
print "            padding: 10px;\n";
print "            border-radius: 5px;\n";
print "            overflow: auto;\n";
print "        }\n";
print "        .button {\n";
print "            display: block;\n";
print "            width: 200px;\n";
print "            margin: 20px auto;\n";
print "            padding: 10px;\n";
print "            text-align: center;\n";
print "            background-color: #007bff;\n";
print "            color: #fff;\n";
print "            text-decoration: none;\n";
print "            border-radius: 5px;\n";
print "        }\n";
print "    </style>\n";
print "</head>\n";
print "<body>\n";
print "    <div class='container'>\n";
print "        <h1>Resumen del estado del sistema</h1>\n";
print "        <h2>Carga de la CPU</h2>\n";
print "        <p>User: $user, Nice: $nice, Sys: $sys, Idle: $idle</p>\n";
print "        <h2>Uso de Memoria</h2>\n";
print "        <p>$used_mem MB de $total_mem MB utilizados</p>\n";
if ($used_disk && $total_disk && $free_disk) {
    print "        <h2>Uso de Disco</h2>\n";
    print "        <p>$used_disk GB de $total_disk GB utilizados (Libre: $free_disk GB - $porcentaje %)</p>\n";
} else {
    print "        <h2>Uso de Disco</h2>\n";
    print "        <p>No disponible</p>\n";
}

print "    <a class='button' href='http://192.168.1.85:8080/monitorix'>Acceso a Monitorix</a>\n";
print "    <a class='button' href='/perl-bin/daily_report.sh'>Adelantar envio de estadisticas diarias</a>\n";


print "    </div>\n";
print "</body>\n";
print "</html>\n";
