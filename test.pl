#!perl -w

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..1\n"; }

END {print "not ok 1\n" unless $loaded;}

use IO::Extended ':all';

use strict;

use warnings;

use diagnostics;

our $loaded = 1;

print "ok 1\n";

	for( 0..10 )
	{
		printf "set tabsize = %s\n", tabs( $_ );

		for( 0..10 )
		{
			printfln 'set indentation = %s', ind( $_ );

			println 'Hello, this is println calling..';

			printfln 'Hello, this is %s calling..', 'printfln';

			print my $out = sprintfln 'Hello, this is %s calling..', 'sprintfln';
		}

		for( 0..10)
		{
			printfln 'set indentation = %s', indb;

			println 'Hello, this is println calling..';

			printfln 'Hello, this is %s calling..', 'printfln';

			print my $out = sprintfln 'Hello, this is %s calling..', 'sprintfln';
		}
	}

	$_ = 'ALL RIGHT';

	println;

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

