#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use CGI;


use Email::Send::SMTP::Gmail;


use URI;


use Digest::SHA qw(sha256_hex);




my $cgi = CGI->new();

print $cgi->header;

my $correo = $cgi->param("email");


	
                my $dbh = eval {
                            DBI->connect('DBI:MariaDB:database=DIAserver;host=localhost',
                         'admin', '9741', { RaiseError => 1, PrintError => 0 });
                };

                if ($@) {
                              print "Error al conectar: $@\n";
                }


                my $sth = $dbh->prepare('SELECT id, email FROM users WHERE email = ?');
                $sth->execute($correo);

		if(my $row = $sth->fetchrow_hashref()){
		
			my $id = $row->{id};

		

                      
			
			my $token = secure_token_generator();

			my $created_time = time();

                        my $sth = $dbh->prepare('INSERT INTO password_reset_tokens (id_usuario, email, token, time) VALUES (?, ?, ?, ?)');


                        eval {
                                    $sth->execute($id, $correo, $token,  $created_time);
                        };

                        if ($@) {

                                    print "Error al insertar los datos: $@\n";
                        } 

          

	
                   

			my $uri = URI->new('http://192.168.1.85/perl-bin/repass.pl');


			$uri->query_form(
			    token => $token,
			);


			my $reset_link = $uri->as_string;

		       
		   
			my $send_body = "<h1>Proceso de recuperación de contraseña:</h1> <p>Haga click en el siguiente enlace para restablecer su contraseña:</p>
			<a href=\"$reset_link\">Restablecer contraseña</a><br> <small> Att: El administrador de Diaserver</small>";                     


                        my ($mail,$error)=Email::Send::SMTP::Gmail->new(-smtp=>'smtp.gmail.com',-login=>'diaserver33@gmail.com',-pass=>'clqjgoknkieglkmj');

                        print "session error $error" unless ($mail!=-1);

                        $mail->send(-to=>$correo,-subject=>'Recuperacion de password', -body=>$send_body, -contenttype=>'text/html');


                     





print <<EOF;
<!DOCTYPE html>
<html>
<head>
    <title>Reestablecimiento de contraseña</title>
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
        <h2>Reestablecimiento de password</h2>
        <h3>Revise su bandeja de correo electronico y siga las instrucciones.</h3>
     
EOF
print <<EOF;
    </div>
</body>
</html>
EOF



			
	

		}else{

			print "El correo $correo no tiene una cuenta vinculada.";


		}


                $sth->finish;
                $dbh->disconnect;




sub secure_token_generator {
    my $length = 32;
    my @chars = ('a'..'z', 'A'..'Z', '0'..'9', '-', '_');
    my $token = '';


    for (1..$length) {
        $token .= $chars[rand(@chars)];
    }

    return $token;
}




