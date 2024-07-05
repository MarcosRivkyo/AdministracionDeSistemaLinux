#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use CGI;


use CGI::Session;
use Authen::Simple::PAM;


use Digest::SHA qw(sha256_hex);
use Sys::Syslog qw(:standard :macros);


my $cgi = CGI->new();

my $session = CGI::Session->new;
my $sid = $session->id();


my $username = $cgi->param("username");
my $password = $cgi->param("password");
my $remote_ip = $cgi->remote_host();



		unless ($username && $password) {

                        print $cgi->redirect("/index.html?resultado=errenter");

		   	exit;
		}

	        

                openlog('login', 'ndelay,pid', LOG_USER);
      	     


		my $pam = Authen::Simple::PAM->new(
				    service => 'login'
		);


		

		if ( $pam->authenticate( $username, $password ) ) 
		{
			        

				$session->param('username', $username);
				$session->param('password', $password);



				$session->expire("+1h");
				$session->flush();

			        syslog(LOG_INFO, "User %s successfully logged in from %s", $username, $remote_ip);


			        print $session->header(-location => "/perl-bin/redirect.pl?session_id=$sid");
			        print "<meta http-equiv='refresh' content='1; /perl-bin/redirect.pl?session_id=$sid'>";

		}

		else
		{


		       syslog(LOG_WARNING, "Failed login attempt for user %s from %s", $username, $remote_ip);


                        print $cgi->redirect("/index.html?resultado=errenter");
			       
		}

	

		   
closelog();

