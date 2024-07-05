#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use CGI;


use Linux::usermod;
use Digest::SHA qw(sha256_hex);


my $cgi = CGI->new;

print $cgi->header;

my $password = $cgi->param("password");
my $token = $cgi->param("token");



    my $dbh = DBI->connect("DBI:MariaDB:database=DIAserver;host=localhost", "admin", "9741", {'RaiseError' => 1});

   
    my $sth = $dbh->prepare("SELECT id_usuario FROM password_reset_tokens WHERE token = ?");
    $sth->execute($token);

    if (my $row = $sth->fetchrow_hashref()) {
        my $id = $row->{id_usuario};

   

	$dbh = DBI->connect("DBI:MariaDB:database=DIAserver;host=localhost", "admin", "9741") or die "Error al conectar a la base de datos: $DBI::errstr";

        my $coded_password = sha256_hex($password);
	my $update_query = "UPDATE users SET password = ? WHERE id = ?";


	$sth = $dbh->prepare($update_query);
	$sth->execute($coded_password, $id) or die "Error al ejecutar la consulta de actualización: $DBI::errstr";
	

	 $sth = $dbh->prepare("SELECT username FROM users WHERE id = ?");
    	 $sth->execute($id);
	
         my $username = $sth->fetchrow_array;


	 my $user = Linux::usermod->new($username);
         $user->set("password",$password);


	if ($sth->rows > 0) {
		    
		print <<EOF;
		
		<!DOCTYPE html>
			<html>
			<head>
				    <title>Contraseña actualizada</title>
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
        <h2>Contrasena actualizada</h2>
        <h3>Se han modificado sus datos de acceso, ahora podra acceder con su nueva contrasena</h3>
        <label>Gracias por confiar en nosotros. Att. El administrador de DIA-server</label>
	<br><br>
        <button type="button" onclick="window.location.href='/index.html';">Volver a la pagina principal</button>


	
<EOF;
	    </div>
	</body>
</html>
EOF




	
	
	} else {
		    print "No se actualizo.\n";
	




	}


	$sth->finish();

       
    }

       
    



    $dbh->disconnect;
    


