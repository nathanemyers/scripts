#!/usr/bin/perl

use strict;
use sigtrap 'handler' => \&killtrap, 'INT';

# author - Nathan Myers (nathanemyers@gmail.com)
# JUN/2011

# this tool scp's a file to each non-capitalized host in your .ssh/config file
# I find that it's a pretty handy thing to have around

open( CONFIGFILE, "/home/nathan/.ssh/config" )
  or die "Unable to open ssh config file!";
my $num_args = $#ARGV + 1;
if ( $num_args < 1 ) {
    print "USAGE: ./propagate <file> [<destination location>]\n";
    exit;
}
my $line;
my $file     = $ARGV[0];
my $location = "~/";
if ( $num_args == 2 ) {
    $location = $ARGV[1];
}
print "Propagating [$file -> $location]";

my @hosts;
while ( $line = <CONFIGFILE> ) {
    if ( $line =~ m/^host=([^A-Z].*)/ ) {
        push( @hosts, $1 );
    }
}
my $sentcounter = 0;
for my $host (@hosts) {
    print ".";
    if ( -d $file ) {
        `scp -r $file $host:$location`;
    }
    else {
        `scp $file $host:$location`;
    }
    $sentcounter++;
}
print "\n";

sub killtrap() {
    print "\n** Process Aborted! **\n";
    for my $host (@hosts) {
        if ( $sentcounter > 0 ) {
            print "Sent: $host\n";
        }
        else {
            print "Failed: $host\n";
        }
        $sentcounter--;
    }
    exit(1);
}
