#!/usr/bin/perl


use strict;
use warnings;

use DBI;
use CGI;

use CGI::Session;


my $cgi = CGI->new;

my $session = CGI::Session->new();

my $username = $session->param('username');

    print $cgi->header('text/plain');

    print $username;
