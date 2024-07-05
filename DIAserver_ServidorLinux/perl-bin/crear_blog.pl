#!/usr/bin/perl

use strict;
use warnings;
use File::Path qw(make_path);

use CGI;
use CGI::Session;

my $cgi = CGI->new;


my $session = CGI::Session->new();
my $sid = $session->id();


my $username = $session->param('username');


my $base_dir = '/var/www/html/blogs/';

my $user_blog_dir = $base_dir . $username;

if (-e $user_blog_dir) {
   
 print "Content-Type: text/html\n\n";
    print "<html><head>";
    print "<style>";
    print "body {";
    print "    font-family: Arial, sans-serif;";
    print "    background-color: #57E17F;";
    print "    margin: 0;";
    print "    padding: 0;";
    print "    display: flex;";
    print "    justify-content: center;";
    print "    align-items: center;";
    print "    height: 100vh;";
    print "}";
    print ".container {";
    print "    background-color: #fff;";
    print "    padding: 40px;";
    print "    border-radius: 10px;";
    print "    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);";
    print "    text-align: center;";
    print "}";
    print "h1 {";
    print "    color: #333;";
    print "    margin-bottom: 20px;";
    print "}";
    print "p {";
    print "    color: #666;";
    print "    margin-bottom: 30px;";
    print "}";
    print "a {";
    print "    color: #007bff;";
    print "    text-decoration: none;";
    print "}";
    print "a:hover {";
    print "    color: #0056b3;";
    print "}";
    print "</style>";
    print "</head><body>";
    print "<div class='container'>";
    print "<h1>El blog ya existe para el usuario $username.</h1>";
    print "<p>Accede a tu blog <a href='/blogs/$username/index.html'>aquí</a>.</p>";
    print "</div>";
    print "</body></html>";

} else {
    eval {
        make_path($user_blog_dir, {mode => 0755});


 print "Content-Type: text/html\n\n";
    print "<html><head>";
    print "<style>";
    print "body {";
    print "    font-family: Arial, sans-serif;";
    print "    background-color: #57E17F;";
    print "    margin: 0;";
    print "    padding: 0;";
    print "    display: flex;";
    print "    justify-content: center;";
    print "    align-items: center;";
    print "    height: 100vh;";
    print "}";
    print ".container {";
    print "    background-color: #fff;";
    print "    padding: 40px;";
    print "    border-radius: 10px;";
    print "    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);";
    print "    text-align: center;";
    print "}";
    print "h1 {";
    print "    color: #333;";
    print "    margin-bottom: 20px;";
    print "}";
    print "p {";
    print "    color: #666;";
    print "    margin-bottom: 30px;";
    print "}";
    print "a {";
    print "    color: #007bff;";
    print "    text-decoration: none;";
    print "}";
    print "a:hover {";
    print "    color: #0056b3;";
    print "}";
    print "</style>";
    print "</head><body>";
    print "<div class='container'>";
    print "<h1>Blog creado con exito para el usuario $username.</h1>";
    print "<p>Accede a tu blog <a href='/blogs/$username/index.html'>aquí</a>.</p>";
    print "</div>";
 

    
        my $file_path = "$user_blog_dir/index.html";
        open my $fh, '>', $file_path or die "No se pudo abrir el archivo '$file_path' $!\n";
        print $fh "<h1>Bienvenido al blog del usuario $username</h1>";
        print $fh "<h2>La Revolución de la Inteligencia Artificial</h2>";
        print $fh "<h3>La inteligencia artificial (IA) se ha convertido en uno de los temas más fascinantes y discutidos de nuestra era. Esta tecnología ha evolucionado rápidamente en las últimas décadas, transformando la forma en que vivimos, trabajamos y nos relacionamos. En este blog, exploraremos el impacto de la IA en diversos ámbitos y reflexionaremos sobre su futuro.</h3>";
        print $fh "<br><br><h3>Los avances en la IA han sido impresionantes. Hoy en día, los sistemas de IA pueden realizar tareas que antes eran exclusivas de los seres humanos, como reconocimiento de voz, conducción autónoma y diagnóstico médico. Además, el aprendizaje automático ha permitido a las máquinas aprender y adaptarse a partir de datos, lo que ha llevado a un progreso sin precedentes en campos como la robótica y la visión artificial.</h3>";

        close $fh;

      
        print "</body></html>";
    };
    if ($@) {
        print "Content-Type: text/html\n\n";
        print "<html><body>";
        print "<h1>Error al crear el directorio del blog: $@</h1>";
        print "</body></html>";
    }
}

