#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

BEGIN{ use_ok('Dependencio');}


diag( "Testing Dependencio $Dependencio::VERSION, Perl $], $^X" );


ok( checkDeps() , "runmain" );


done_testing();
