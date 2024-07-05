#!/usr/bin/perl

use strict;
use warnings;
use Excel::Writer::XLSX;
use Email::Send::SMTP::Gmail;
use POSIX qw(strftime);  
use MIME::Base64;  


sub get_cpu_load {
    my $mpstat_output = `mpstat`;

        return $mpstat_output;
}

sub get_memory_usage {
    my $memory_usage = `free -m`;
    
    return $memory_usage;
}

sub get_disk_usage {
    my $disk_usage = `df -h /`;

    return $disk_usage;
}



open(my $fh, '<', 'estadisticas.txt') or die "No se pudo abrir el archivo 'archivo.txt' $!";

my @porcentajes;
my @comandos;

while (my $linea = <$fh>) {
    my @cachos = split(' ', $linea);

    push @porcentajes, $cachos[1];
    push @comandos, $cachos[8];
}




close($fh);


my @valores_numericos;

foreach my $porcentaje (@porcentajes) {
    my ($numero) = $porcentaje =~ /(\d+\.\d+)/;
    my $valor_numerico = $numero / 100;
    push @valores_numericos, $numero;
}




my $workbook  = Excel::Writer::XLSX->new( 'chart_pie.xlsx' );
my $worksheet = $workbook->add_worksheet();
my $bold      = $workbook->add_format( bold => 1 );

my $headings = [ 'Comando', 'Porcentaje' ];
my $data = [
        \@comandos,
        \@valores_numericos,

];

$worksheet->write_row( 'A1', $headings, $bold );
$worksheet->write_row( 'A2', $data);



my $chart = $workbook->add_chart( type => 'pie', embedded => 1 );


$chart->add_series(
    name       => 'Pie sales data',
    categories => [ 'Sheet1', 1, scalar @comandos, 0, 0 ],
    values     => [ 'Sheet1', 1, scalar @porcentajes, 1, 1 ],
);

$chart->set_title( name => 'Comandos y Porcentajes' );

$chart->set_style( 10 );

$worksheet->insert_chart( 'C2', $chart, 25, 10);



my $fecha_actual = strftime("%d-%m-%Y", localtime);


my $titulo_formato = $workbook->add_format(bold => 1, size => 14);

$worksheet->write('C18', 'RECOLECCION DE ESTADISTICAS DIARIAS', $titulo_formato);
$worksheet->write('H18', "FECHA: $fecha_actual",$titulo_formato);



my $carga_cpu = get_cpu_load();

$worksheet->write('A19', "		CARGA DE CPU");
$worksheet->write('A20', $carga_cpu);

my $memory_usage = get_memory_usage();

$worksheet->write('A22', "              USO DE MEMORIA");
$worksheet->write('A23', $memory_usage);


my $disk_usage = get_disk_usage();

$worksheet->write('A25', "              USO DE DISCO");
$worksheet->write('A26', $disk_usage);



$workbook->close();


my $email = 'marcos.rivkyo@usal.es';
my $email_postfix = 'servidor@diaserver.org';


my $body = "Estadisticas diarias del servidor DIAserver";
my ($mail,$error)=Email::Send::SMTP::Gmail->new(-smtp=>'smtp.gmail.com',-login=>'diaserver33@gmail.com',-pass=>'clqjgoknkieglkmj');
print "session error $error" unless ($mail!=-1);
$mail->send(-to=>$email,-subject=>'daily report', -body=>$body, -attachments=>'chart_pie.xlsx');
$mail->bye;




send_via_postfix($email_postfix, 'daily report', $body, 'chart_pie.xlsx');

sub send_via_postfix {
    my ($to, $subject, $body, $attachment) = @_;
    
    my $boundary = "====" . time() . "====";
    my $file_content;

    # Read the attachment content
    open my $fh, '<', $attachment or die "Could not open file '$attachment' $!";
    {
        local $/;
        $file_content = <$fh>;
    }
    close $fh;

    my $encoded_content = encode_base64($file_content);

    open(MAIL, "|/usr/sbin/sendmail -t");

    # Email Header
    print MAIL "To: $to\n";
    print MAIL "Subject: $subject\n";
    print MAIL "MIME-Version: 1.0\n";
    print MAIL "Content-Type: multipart/mixed; boundary=\"$boundary\"\n\n";
    print MAIL "--$boundary\n";
    
    # Email Body
    print MAIL "Content-Type: text/plain\n\n";
    print MAIL "$body\n";
    print MAIL "--$boundary\n";
    
    # Attachment
    print MAIL "Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet; name=\"$attachment\"\n";
    print MAIL "Content-Transfer-Encoding: base64\n";
    print MAIL "Content-Disposition: attachment; filename=\"$attachment\"\n\n";
    print MAIL "$encoded_content\n";
    print MAIL "--$boundary--\n";
    
    close(MAIL);
}

__END__









