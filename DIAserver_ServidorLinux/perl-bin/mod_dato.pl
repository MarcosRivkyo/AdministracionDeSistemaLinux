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



my $email = $cgi->param('email');
my $nombre = $cgi->param('nombre');
my $apellido = $cgi->param('apellido');
my $address = $cgi->param('address');
my $phone = $cgi->param('phone');



   


                my $dbh = eval {
                            DBI->connect('DBI:MariaDB:database=DIAserver;host=localhost',
                         'admin', '9741', { RaiseError => 1, PrintError => 0 });
                };

                if ($@) {
                              print "Error al conectar: $@\n";
               }



                my $sth=$dbh->prepare('SELECT * FROM users WHERE username=?') or warn $dbh->errstr;

                $sth->execute($username) or die $sth->errstr;

                my @chk = $sth->fetchrow_array();

           	if ($email eq ""){$email = @chk[7];}
	        if ($nombre eq ""){$nombre = @chk[3];}
	        if ($apellido eq ""){$apellido = @chk[4];}
        	if ($address eq ""){$address = @chk[5];}
	        if ($phone eq ""){$phone = @chk[6];}
              


                
		 $sth=$dbh->prepare('UPDATE users SET email=?, name=?, surname=?, address=?, mobilephone=? WHERE username=?') or warn $dbh->errstr;

                $sth->execute($email, $nombre, $apellido, $address, $phone, $username) or die $sth->errstr;
                
                $sth->finish;

                $dbh->disconnect;
	                         

		print $cgi->redirect("/alumno.html?session_id=$sid");


               


        




