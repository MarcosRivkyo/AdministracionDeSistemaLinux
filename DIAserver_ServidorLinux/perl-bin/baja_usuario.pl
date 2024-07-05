#!/usr/bin/perl


use strict;
use warnings;

use DBI;
use CGI;

use CGI::Session;
use Sudo;

use Linux::usermod;
use IPC::Run qw(run);


my $cgi = CGI->new;

my $session = CGI::Session->new();

my $sid = $session->id();

my $username = $session->param('username');
my $rol = $session->param('rol');





                my $dbh = eval {
                            DBI->connect('DBI:MariaDB:database=DIAserver;host=localhost',
                         'admin', '9741', { RaiseError => 1, PrintError => 0 });
                };

                if ($@) {
                              print "Error al conectar: $@\n";
               }



        	  my $sth=$dbh->prepare('DELETE FROM users WHERE username=?') or warn $dbh->errstr;
	
	        $sth->execute($username) or die $sth->errstr;	

                $sth->finish;

                $dbh->disconnect;


        	  my $user = Linux::usermod->del($username);

		  my $grp = Linux::usermod->grpdel($username);




		        my $args_1 = "-rf /home/$username";
                        my $su_1 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/rm',
                                program_args    => $args_1

                        });

                        my $result_1 = $su_1->sudo_run();


                        my $args_2 = "-rf /sftp/$username";
                        my $su_2 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/rm',
                                program_args    => $args_2

                        });

                        my $result_2 = $su_2->sudo_run();


                        my $args_3 = "-d $username alumnos";
                        my $su_3 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/gpasswd',
                                program_args    => $args_3

                        });

                        my $result_3 = $su_3->sudo_run();

                        my $args_4 = "-d $username profesores";
                        my $su_4 = Sudo->new({
                                sudo            => '/usr/bin/sudo',
                                username        => 'root',
                                password        => '9741',
                                 program         => '/usr/bin/gpasswd',
                                program_args    => $args_4

                        });

                        my $result_4 = $su_4->sudo_run();

      

          print $cgi->redirect("/index.html");





