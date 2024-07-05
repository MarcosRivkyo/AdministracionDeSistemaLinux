#!/usr/bin/perl

use CGI;
use CGI::Session;
use DBI;

use Email::Send::SMTP::Gmail;

use POSIX qw(strftime);


my $cgi = new CGI;


my $sid = $cgi->param('session_id');

my $session = CGI::Session->new($sid);



if ($session->is_expired){

        $session->delete();
        $session->flush();

        print $cgi->redirect("/index.html");

}
else{

        my $username = $session->param("username");
        my $password = $session->param("password");
        

        my $db=DBI->connect('dbi:mysql:database=DIAserver;host=localhost','admin','9741');

        my $sth=$db->prepare('SELECT role, is_admin FROM users WHERE username=?') or warn $db->errstr;

        $sth->execute($username) or die $sth->errstr;

        my @user= $sth->fetchrow_array;
        $sth->finish();

        if(@user ne 0){
                my $role = @user[0];
                my $admin = @user[1];


		$session->param('rol', $role);
		$session->flush();
		
       
                if ($admin eq 1){

                       


			#Envia un correo por razones de seguridad
			
		
			my $current_time = strftime "%Y-%m-%d %H:%M:%S", localtime;


			my $email = 'marcos.rivkyo@usal.es';

                        my $send_body = "<h1>Acceso de Admin. detectado:</h1><br><p>Un usuario se ha logueado como administrador en el sistema, a las $current_time.</p>
                        <br> <small> Att: El administrador de Diaserver</small>";


                        my ($mail,$error)=Email::Send::SMTP::Gmail->new(-smtp=>'smtp.gmail.com',-login=>'diaserver33@gmail.com',-pass=>'clqjgoknkieglkmj');

                        print "session error $error" unless ($mail!=-1);

                        $mail->send(-to=>$email,-subject=>'Acceso de Administrador en DIA-server', -body=>$send_body, -contenttype=>'text/html');
	


                        print $cgi->redirect("/admin.html");


                }elsif ($role eq 1){
                              
		         print $cgi->redirect("/alumno.html?session_id=$sid");

               }elsif($role eq 2){

                        print $cgi->redirect("/profesor.html?session_id=$sid");                    

                }

	}else{

                print $cgi->redirect("/index.html");

        }


}
