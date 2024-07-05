#!/usr/bin/perl
use strict;
use warnings;
use Email::Send;
use Email::Send::Gmail;
use Email::Simple::Creator;
use CGI;



my $cgi = CGI->new;
print $cgi->header;

my $nombre = $cgi->param('nombre');
my $correo = $cgi->param('correo');
my $mensaje_user = $cgi->param('mensaje');

my $mensaje = "Nombre: $nombre\nCorreo electronico: $correo\nMensaje:$mensaje_user\n";


if (!$nombre || !$correo || !$mensaje_user) {

    print "<script>window.location.href = '/index.html?resultado=errmail';</script>";

}else{

 
my $email = Email::Simple->create(
    header => [
        From    => 'diaserver33@gmail.com',
        To      => 'marcos.rivkyo@usal.es',
        Subject => 'Mensaje de contacto enviado a traves de DIA_Server',
    ],
    body => $mensaje,
);
 
my $sender = Email::Send->new(
    {   mailer      => 'Gmail',
        mailer_args => [
            username => 'diaserver33@gmail.com',
            password => 'clqjgoknkieglkmj',
        ]
    }
);
eval { $sender->send($email) };

if ($@) {

      print "<script>window.location.href = '/index.html?resultado=errmail';</script>";
   
} else {

      print "<script>window.location.href = '/index.html?resultado=succmail';</script>";
	
}



}
