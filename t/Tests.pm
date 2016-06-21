package Tests;

use strict; #this should be removed on parsing
use warnings; #also removed on parsing
use Tests::Lol::Cat; #some unexistent modules
use Tests::Nyan::Cat;
use Tests::Nyan::Cat;#yes, twice to test if appears only once in the parsing
use Tests::Super::Powers;

#add some weird forms of modules to clean
use Encode qw(encode);
use Lolez::Lolus #this is a comment and should be removed from parsing
use Mojo::Base 'Mojolicious';
use Modulefoo::Lulz "something in quotes";
use ModuleLol ();


1;

