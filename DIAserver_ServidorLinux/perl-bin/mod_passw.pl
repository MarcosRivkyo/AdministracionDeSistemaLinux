#!/usr/bin/perl


use strict;
use warnings;

use DBI;
use CGI;

use CGI::Session;

use Linux::usermod;

use Digest::SHA qw(sha256_hex);



my $cgi = CGI->new;



my $session = CGI::Session->new();

my $sid = $session->id();
 
my $username = $session->param('username'); 
my $password = $session->param('password');
my $rol = $session->param('rol');

my $passw_actual = $cgi->param('oldPassword');
my $passw_nueva = $cgi->param('newPassword1');
my $passw_nueva2 = $cgi->param('newPassword2');



        if($passw_nueva ne $passw_nueva2){

                print $cgi->redirect("/ajustes.html?error&session_id=$sid");

        }

        if($passw_nueva eq $passw_actual){

                print $cgi->redirect("/ajustes.html?error&session_id=$sid");

        }

	else{

	        my $coded_password = sha256_hex($passw_actual);


                my $dbh = eval {
                            DBI->connect('DBI:MariaDB:database=DIAserver;host=localhost',
                         'admin', '9741', { RaiseError => 1, PrintError => 0 });
                };

                if ($@) {
                              print "Error al conectar: $@\n";
               }



                my $sth=$dbh->prepare('SELECT password FROM users WHERE username=?') or warn $dbh->errstr;

                $sth->execute($username) or die $sth->errstr;

                my $chk = $sth->fetchrow_array;

                if($chk ne $coded_password){
                           
		                print $cgi->redirect("/ajustes.html?error&session_id=$sid");
                              
                }
                else{


                my $new_coded_password = sha256_hex($passw_nueva);

     
		my $sth=$dbh->prepare('UPDATE users SET password=? WHERE username=?') or warn $dbh->errstr;

                $sth->execute($new_coded_password, $username) or die $sth->errstr;

                $sth->finish;


                $dbh->disconnect;
	                        
		my $user = Linux::usermod->new($username);
                $user->set("password",$passw_nueva);


		
		if($rol == 1){

                                 print $cgi->redirect("/alumno.html?session_id=$sid");


		}elsif($rol == 2){

                                 print $cgi->redirect("/profesor.html?session_id=$sid");

		}

	                       
               }


        }




