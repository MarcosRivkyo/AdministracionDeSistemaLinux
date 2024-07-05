#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use CGI;
use CGI::Session;



use Email::Send::SMTP::Gmail;


use Linux::usermod;

use File::Copy::Recursive qw(dircopy);
use File::Path qw(make_path);
use Digest::SHA qw(sha256_hex);
use File::Copy;
use File::chown;

use Sudo;
use IPC::Run qw(run);



my $cgi = CGI->new;
print $cgi->header;

my $sid = $cgi->param('session_id'); 
my $session = CGI::Session->new($sid);



my $username = $session->param('username');
my $password = $session->param('password');
my $name = $session->param('name');
my $surname = $session->param('surname');
my $email = $session->param('email');
my $address = $session->param('address');
my $phone = $session->param('phone');
my $role = $session->param('role');
my $is_admin = $session->param('is_admin');
my $local_email = $session->param('local_email');


my $home = "/home/$username";
my $shell    = "/bin/bash";
my $root = "root";





	                my $dbh = eval {
		                            DBI->connect('DBI:MariaDB:database=DIAserver;host=localhost',
		                         'admin', '9741', { RaiseError => 1, PrintError => 0 });
        	        };

	
	                if ($@) {
                              
					operacion_fallida($username);
					print "Error al conectar: $@\n";
				      
	               }

         		my $coded_password = sha256_hex($password);


   			    my $sth = $dbh->prepare('INSERT INTO users (username, password, name, surname, address, mobilephone, email, localemail, role, is_admin) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');


                        eval {
                                    $sth->execute($username, $coded_password, $name, $surname, $address, $phone, $email, $local_email, $role, $is_admin);
                        };

                        if ($@) {

                                       operacion_fallida($username);
                                       print "Error al insertar el usuario: $@\n";


                        }

                                    $sth->finish();
     



	
	                    Linux::usermod->add($username, $password, '', '', '', $home, $shell);
		
				         my $user=Linux::usermod->new($username);
                       
		                Linux::usermod->grpadd($username, $user->get('gid'));
                       
		                my $gr = Linux::usermod->new($username, 1);
                       
		                $gr->set('users',$username);		





                        my $args_1 = "/home/$username";
                        my $su_1 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/mkdir',
                                program_args    => $args_1

                        });

                        my $result_1 = $su_1->sudo_run();



                        my $args_2 = "755 /home/$username";
                        my $su_2 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/chmod',
                                program_args    => $args_2

                        });

                        my $result_2 = $su_2->sudo_run();



                        my $args_3 = "-R $username:$username /home/$username";
                        my $su_3 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/chown',
                                program_args    => $args_3

                        });

                        my $result_3 = $su_3->sudo_run();




                        my $args_4 = "/sftp/$username";
                        my $su_4 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/mkdir',
                                program_args    => $args_4

                        });

                        my $result_4 = $su_4->sudo_run();




                        my $args_5 = "770 /sftp/$username";
                        my $su_5 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/chmod',
                                program_args    => $args_5

                        });

                        my $result_5 = $su_5->sudo_run();




                        my $args_6 = "-R $root:$username /sftp/$username";
                        my $su_6 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/chown',
                                program_args    => $args_6

                        });

                        my $result_6 = $su_6->sudo_run();



                        my $args_7 = "/sftp/$username/ApuntesPersonales";
                        my $su_7 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/mkdir',
                                program_args    => $args_7

                        });

                        my $result_7 = $su_7->sudo_run();





                        my $args_8 = "775 /sftp/$username/ApuntesPersonales";
                        my $su_8 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/chmod',
                                program_args    => $args_8

                        });

                        my $result_8 = $su_8->sudo_run();




                        my $args_9 = "$root:$username /sftp/$username/ApuntesPersonales";
                        my $su_9 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/chown',
                                program_args    => $args_9

                        });

                        my $result_9 = $su_9->sudo_run();




                        my $args_10 = "/sftp/$username/ApuntesClase";
                        my $su_10 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/mkdir',
                                program_args    => $args_10

                        });

                        my $result_10 = $su_10->sudo_run();



                        my $args_11 = "775 /sftp/$username/ApuntesPersonales";
                        my $su_11 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/chmod',
                                program_args    => $args_11

                        });

                        my $result_11 = $su_11->sudo_run();




                        my $args_12 = "$root:$username /sftp/$username/ApuntesPersonales";
                        my $su_12 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/chown',
                                program_args    => $args_12

                        });

                        my $result_12 = $su_12->sudo_run();



                        my $args_13 = "-s /apuntes /sftp/$username/ApuntesClase"; 
			
			            my $su_13 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/ln',
                                program_args    => $args_13

                        });

                        my $result_13 = $su_13->sudo_run();


                  


		     	               		       
                        my $cp_command = "cp";
                        my @cp_args = ("-R", "/etc/skel/.", "/sftp/$username");
                        my @sudo_cp_command = ("sudo", $cp_command, @cp_args);
                        run \@sudo_cp_command or die "Error ejecutando el comando cp con sudo: $?\n";


					
		

			if ($role == 1){

			

		
				        my $grp_A = Linux::usermod->new("alumnos", 200);
   		                my $usr_A = $grp_A->get('users');
	                    my @usr_A_split = split(',', $usr_A);
                		push(@usr_A_split, $username);
		                $grp_A->set('users',"@usr_A_split");
			
				        my $fichero1 = "/var/www/html/alumno.html";
				        my $destino = "/home/$username/pagina_personal/";			

			
        				unless (-d $destino) {
		  					   
					            my $command = "mkdir";
					            my @args = ("/home/$username/pagina_personal/");
					            my @sudo_command = ("sudo", $command, @args);
				    	            run \@sudo_command or die "Error ejecutando el comando con sudo: $?\n";
				        }

             
				        my $cp_command = "cp";
				        my @cp_args = ($fichero1,$destino);  
				        my @sudo_cp_command = ("sudo", $cp_command, @cp_args);
				        run \@sudo_cp_command or die "Error ejecutando el comando cp con sudo: $?\n";


			}else{
                             


                            my $grp_P = Linux::usermod->new("profesores", 201);
        	                my $usr_P = $grp_P->get('users');
	                        my @usr_P_split = split(',', $usr_P);
                	        push(@usr_P_split, $username);
	                        $grp_P->set('users',"@usr_P_split");

	                        my $fichero1 = "/var/www/html/profesor.html";
	                        my $destino = "/home/$username/pagina_personal/";


	                        unless (-d $destino) {
                        

                                my $command = "mkdir";
                                my @args = ("/home/$username/pagina_personal/");
                                my @sudo_command = ("sudo", $command, @args);
                                run \@sudo_command or die "Error ejecutando el comando con sudo: $?\n";

                        }

			        my $cp_command = "cp";
			        my @cp_args = ($fichero1,$destino);  
        			my @sudo_cp_command = ("sudo", $cp_command, @cp_args);
			        run \@sudo_cp_command or die "Error ejecutando el comando cp con sudo: $?\n";

				
			}	    

	                my $args_20 = "-u $username 70M 80M 0 0 /";
        	        my $su_20 = Sudo->new({
	                        sudo            => '/usr/bin/sudo',
	                        username        => 'root',
                	        password        => '9741',
        	                 program         => '/sbin/setquota',
	                        program_args    => $args_20

        	        });
	
	                my $result_20 = $su_20->sudo_run();



			my $body = "<h1>$username, su cuenta ha sido activada!</h1> <p>Su cuenta en Diaserver ha sido activada correctamente.</p> <p>Ahora podrá disfrutar de todos nuestros servicios.</p><p>Visite nuestro sitio web para comenzar: <a href='https://192.168.1.85'>https://diaserver.org</a></p> <p>Gracias por elegirnos.</p> <small>Atentamente,<br>El equipo de Diaserver</small>"; 

                        my ($mail,$error)=Email::Send::SMTP::Gmail->new(-smtp=>'smtp.gmail.com',-login=>'diaserver33@gmail.com',-pass=>'clqjgoknkieglkmj');

                        print "session error $error" unless ($mail!=-1);


	                my $pdf_path = '/var/www/html/assets/man/Ayuda_DIAserver.pdf';

                  
                        $mail->send(-to=>$email,-subject=>'Cuenta activada', -body=>$body, -contenttype=>'text/html', -attachments => $pdf_path);


			operacion_exitosa($username);


				
			$session->expire("+1h");
			$session->flush();


			print "<meta http-equiv='refresh' content='4; URL=/index.html'>";
		
			     
exit;


   

sub operacion_exitosa {
    my $username = shift;

   

    print <<EOF;
<!DOCTYPE html>
<html>
<head>
    <title>Cuenta activada</title>
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
        <h2>Cuenta activada y registrada correctamente</h2>
        <h3>$username, Bienvenido a DIA-server, ahora podra acceder a todos nuestros servicios!</h3>
        <label>Gracias por confiar en nosotros. Att. El administrador de DIA-server</label>
    </div>
</body>
</html>
EOF
}



sub operacion_fallida {
    my $username = shift;

    print <<EOF;
<!DOCTYPE html>
<html>
<head>
    <title>Error en el registro</title>
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
        <h2>Error al crear y registrar la nueva cuenta</h2>
        <h3>$username, Ha ocurrido un error y no se ha podido completar su registro.</h3>
        <label>Disculpe las molestias. Att. El administrador de DIA-server</label>
    </div>
</body>
</html>
EOF
}

