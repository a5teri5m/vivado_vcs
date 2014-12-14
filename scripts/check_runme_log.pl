#!/usr/bin/perl

use strict;
use warnings;

if (@ARGV != 1) {
    print "Usage: check_runs.pl <logfile>\n";
    exit 1;    
}


my ($infos, $warns, $cwarns, $errors) = (0, 0, 0, 0);

open(FILE, "< $ARGV[0]") or die "$!";

while (my $line = <FILE> ) {
    chomp($line);
    if ($line =~ /^INFO:.*/ ) {
        $infos++;    
    } elsif ($line =~ /^WARNING:.*/) {
        $warns++;
    } elsif ($line =~ /^CRITICAL WARNING:.*/) {
        $cwarns++;    
    } elsif ($line =~ /^ERROR:.*/) {
        $errors++;   
    }
}
close(FILE);

print "Infos:             $infos\n";    
print "Warnings:          $warns\n";    
print "Critical Warnings: $cwarns\n";    
print "Errors:            $errors\n";    
if ($errors == 0) {
    exit 0;
} else {
    exit 1;    
}


