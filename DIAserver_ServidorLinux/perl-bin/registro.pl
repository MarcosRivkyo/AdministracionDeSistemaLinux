#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use CGI;
use CGI::Session;

use Email::Send::SMTP::Gmail;

use LWP::UserAgent;
use Time::HiRes qw(sleep);
use Sys::Hostname;





my $cgi = CGI->new();
print $cgi->header;

my $session = CGI::Session->new;



my $username = $cgi->param("username1");
my $password = $cgi->param("password");
my $password2 = $cgi->param("password2");
my $name = $cgi->param("name");
my $surname = $cgi->param("surname");
my $email = $cgi->param("email");
my $address = $cgi->param("address");
my $phone = $cgi->param("mobilephone");
my $role = $cgi->param("role");
my $admin = $cgi->param("admin");


my $is_admin = $admin ? 1 : 0;


my $local_email = $username."@".hostname;


my $session_id = $session->id();




$session->param('username', $username);
$session->param('password', $password);
$session->param('name', $name);
$session->param('surname', $surname);
$session->param('email', $email);
$session->param('address', $address);
$session->param('phone', $phone);
$session->param('local_email', $local_email);
$session->param('is_admin', $is_admin);


$session->expire("+1h");
$session->flush();


my @reserved_usernames = qw(
    root admin administrator user guest test mariadb postfix ssh apache2
    webmail sftp ftp mail www data www-data backup bin daemon games irc
    list log news nobody proxy sys sync syslog uucp backup debian-exim 
    postfix roundcube dovecot exim mailman mysql nagios clamav snmp
    wwwrun htdocs mailer-daemon noreply support helpdesk postmaster
);





if($password ne $password2){

	operacion_fallida();
   
        print "<script>setTimeout(function() { window.location.href = '/index.html?resultado=errpass'; }, 4000);</script>";


} elsif ($username =~ /^\s*$/ || $password =~ /^\s*$/ || $name =~ /^\s*$/ || $surname =~ /^\s*$/ || $email =~ /^\s*$/ || $address =~ /^\s*$/ || $phone =~ /^\s*$/) {



        operacion_fallida();

        print "<script>setTimeout(function() { window.location.href = '/index.html?resultado=errpass'; }, 4000);</script>";




}elsif (grep { lc($username) eq $_ } @reserved_usernames) {

	        operacion_fallida();

        	print "<script>setTimeout(function() { window.location.href = '/index.html?resultado=errpass'; }, 4000);</script>";

}



 else{
	
		

		my $dbh = eval {
			    DBI->connect('DBI:MariaDB:database=DIAserver;host=localhost',
	                 'admin', '9741', { RaiseError => 1, PrintError => 0 });
		};
	
		if ($@) {
		              print "Error al conectar: $@\n";
		}
				  
		my $sth_check = $dbh->prepare('SELECT COUNT(*) FROM users WHERE username = ?');

		eval {
			    $sth_check->execute($username);
		};


		if ($@) {
		  
			    print "Error al ejecutar la consulta: $@\n";
		}
				
		
		my ($user_count) = $sth_check->fetchrow_array;
		
		$sth_check->finish();		

	
		if ($user_count > 0) {


		                operacion_fallida();
			  
			        print "<script>setTimeout(function() { window.location.href = '/index.html?resultado=erruser'; }, 4000);</script>";
			

		}else{


			if($address eq ' '){

				$address = undef;
			
			}
			
			if($phone eq ' '){

				$phone = undef;
			
			}
			
			if($role eq 'Alumno'){
				$role=1;
			}		

                        if($role eq 'Profesor'){
                                $role=2;
                        }
	
		
			$session->param('role', $role);


                        my $uri = URI->new('http://192.168.1.85/perl-bin/activacion.pl');


                        $uri->query_form(
                            session_id => $session_id
                        );
			
		
                        my $url_confirmacion = $uri->as_string;

                        my $send_body = "<h1>Proceso de activacion de cuenta:</h1><br><p>Haga click en el siguiente enlace para activar su cuenta:</p>
                        <br><a href=\"$url_confirmacion\">Activar cuenta</a><br> <small> Att: El administrador de Diaserver</small>";


                        my ($mail,$error)=Email::Send::SMTP::Gmail->new(-smtp=>'smtp.gmail.com',-login=>'diaserver33@gmail.com',-pass=>'clqjgoknkieglkmj');

                        print "session error $error" unless ($mail!=-1);


			            my $img_path = '/var/www/html/assets/img/logo.PNG'; 


                        $mail->send(-to=>$email,-subject=>'Activacion de cuenta', -body=>$send_body, -contenttype=>'text/html', -attachments => $img_path);

			            operacion_exitosa();
			

		}
    	  


}




sub operacion_exitosa {
    print <<"EOF";

<!DOCTYPE html>
<html>
<head>
    <title>Proceso de Registro</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #57E17F;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Activacion de cuenta:</h2>
        <h3>Revise su bandeja de correo electronico y siga las instrucciones.</h3>
    </div>
</body>
</html>
EOF
}   



sub operacion_fallida {
    print <<"EOF";

<!DOCTYPE html>
<html>
<head>
    <title>Proceso de Registro</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #57E17F;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Registro de cuenta fallida:</h2>
        <h3>Ha habido un error disculpe las molestias.</h3>
        <h3>Volvera a la pagina principal en 4 segundos.</h3>

    </div>
</body>
</html>
EOF
}
