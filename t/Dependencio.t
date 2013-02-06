use strict;
use warnings;

use Test::More qw(no_plan);
BEGIN { use_ok('Dependencio') };

diag( "Testing Dependencio $Dependencio::VERSION, Perl $], $^X" );

require_ok('Dependencio');

my $check = checkDeps();
ok( $check," <- es el valor de  pwd " );


