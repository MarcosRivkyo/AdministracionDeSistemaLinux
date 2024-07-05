#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use CGI;

my $cgi = CGI->new;


my $token = $cgi->param("token");



if (validate_token($token)) {
   
    print $cgi->header;
print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restablecer Contraseña</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #57E17F;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        

	}



        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #333;
        }
        label {
            display: block;
            margin-bottom: 10px;
        }
        input[type='password'] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
        button[type='submit'] {
	  width: 100%;
	  padding: 10px;
	  border: none;
	  border-radius: 4px;
	  background-color: #ff6600;
	  color: #fff;
	  font-weight: bold;
	  cursor: pointer;
           
        }

        button[type='submit']:hover {
            background-color: #0056b3;
        }


    </style>
</head>
<body>
    <div class="container">
        <h1>Restablecer Password</h1>
        <form action="/perl-bin/update_password.pl" method="post">
            <input type="hidden" name="token" value="$token">
            <label for="password">Nuevo Password:</label>
            <input type="password" id="password" name="password" required>
            <button type="submit">Introduzca su nuevo password:</button>
        </form>
    </div>
</body>
</html>
HTML
} else {
    # Token inválido o expirado, mostrar mensaje de error
    print $cgi->header(-status => '400 Bad Request');
    print "El enlace para restablecer la contraseña es inválido o ha expirado.";
}



sub validate_token {
    my ($token) = @_;

    my $dbh = DBI->connect("DBI:MariaDB:database=DIAserver;host=localhost", "admin", "9741", {'RaiseError' => 1});

   
    my $sth = $dbh->prepare("SELECT email, token, time FROM password_reset_tokens WHERE token = ?");
    $sth->execute($token);

    if (my $row = $sth->fetchrow_hashref()) {
        my $time = $row->{time};

    

        my $current_time = time();
 

       if (($current_time - $time) <= 86400) {
            
     
	   
	    return 1;
        }
    }
    



    $dbh->disconnect;
    return 0; # Token no es válido o ha expirado
}

