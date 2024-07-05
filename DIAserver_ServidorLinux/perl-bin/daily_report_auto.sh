#!/bin/bash


        sa -nac | head -15 | tail +2 > estadisticas.txt

        /usr/bin/perl /var/www/perl-bin/grafico.pl


