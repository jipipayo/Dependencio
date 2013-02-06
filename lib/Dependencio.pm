package Dependencio;

use strict;
use warnings;
use File::Basename;
use Cwd;

require Exporter;


our @ISA = qw(Exporter);
our @EXPORT = qw(
checkDeps
);

our $VERSION = '0.01';



sub checkDeps{
    my $dir  = getcwd;
    my $path = shift || dirname(__FILE__);

    print STDOUT $dir;
}

1;



__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Dependencio - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Dependencio;
  checkDeps($path);

=head1 DESCRIPTION

This module aims to autodetect all the module dependencies recursively for a project.


=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

dani remeseiro, E<lt>daniel.remeseiro at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by dani remeseiro

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut

