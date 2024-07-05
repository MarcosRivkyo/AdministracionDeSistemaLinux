#!/usr/bin/perl

use strict;
use warnings;
use File::Path qw(remove_tree);

use CGI;
use CGI::Session;

my $cgi = CGI->new;

my $session = CGI::Session->new();
my $sid = $session->id();


my $username = $session->param('username');


my $base_dir = '/var/www/html/blogs/';

my $user_blog_dir = $base_dir . $username;

if (-e $user_blog_dir) {
    eval {
        remove_tree($user_blog_dir);
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
    print "<h1>Se ha eliminado correctamente el blog del usuario $username.</h1>";
    print "</div>";
    print "</body></html>";
        
    };
    if ($@) {
        print "Content-Type: text/html\n\n";
        print "<html><body>";
        print "<h1>Error al eliminar el directorio del blog: $@</h1>";
        print "</body></html>";
    }
} else {
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
    print "<h1>No existe ningún blog para el usuario $username.</h1>";
    print "</div>";
    print "</body></html>";
}

