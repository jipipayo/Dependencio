package Dependencio;

use strict;
use warnings;
use File::Find;
use Cwd;
use IO::File;
require Exporter;


our @ISA = qw(Exporter);
our @EXPORT = qw(checkDeps);
our $VERSION = '0.01';


sub checkDeps{
    my $cwd  = getcwd();

    print STDOUT "$cwd\n";

    my @dirs = ();
    push (@dirs,$cwd);

    find(\&openFiles, @dirs);
}


sub openFiles{
    #only open file types to search module declarations (.pm and .pl)
    if(-f && m/\.(pm|pl)$/){
        print  STDOUT "searching modules uses on $File::Find::name\n";
        my $file = $File::Find::name;

        my $fh = IO::File->new($file, O_RDONLY) or die 'Fuuuuuu! I can not open file ', $file, ": $!";

        while ( my $line =  $fh->getline() ){ #parsing the lines
            #remove spaces at beginning and end of line
            $line=~s/^\s+//;
            $line=~s/\s+$//;
            $line=~s/;//;

            while( $line =~ m/(use |require )[A-Z]{1}/g  ){
                print "$line \n";
            }
        }

        $fh->close;
    }
}
1;



__END__

=head1 NAME

Dependencio - Dumb simple module to find modules dependencies recursively in your project, and check if installed.


=head1 SYNOPSIS



=head1 DESCRIPTION

This module aims to autodetect all the module dependencies recursively for a project.


=head2 EXPORT

checkDeps


=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.


=head1 AUTHOR

dani remeseiro, E<lt>daniel.remeseiro at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by dani remeseiro

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut

