package Dependencio;

use strict;
use warnings;
use File::Find;
use Cwd;
use IO::File;
use Module::Load;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(checkDeps);
our $VERSION = '0.01';


sub checkDeps{
    my $cwd  = getcwd();

    my @dirs = ();
    push (@dirs,$cwd);

    find(\&_openFiles, @dirs);
    return 1;
}


sub _openFiles{
    #only open file types to search module declarations (.pm and .pl)
    if(-f && m/\.(pm|pl)$/){
        print  STDOUT "* checking dependecies on $File::Find::name\n";
        my $file = $File::Find::name;
        my $fh = IO::File->new($file, O_RDONLY) or die 'I can not open file ', $file, ": $!";

        while ( my $line =  $fh->getline() ){
            #remove spaces at beginning and end of line and semicolon
            $line=~s/^\s+//;
            $line=~s/\s+$//;
            $line=~s/;//;

            while( $line =~ m/(use |require )[A-Z]{1}/g  ){
                $line=~s/(use |require )//;

                eval{ load $line };
                if($@) {
                    warn "Dependencio says: module $line not found\n";
                }
            }
        }

        $fh->close;
    }
}
1;



__END__

=head1 NAME

Dependencio - Simple utility to find perl modules dependencies recursively in your project.


=head1 SYNOPSIS



=head1 DESCRIPTION

This module aims to autodetect all the module dependencies recursively in a project.
To be used as standalone application to be part of your continous integration to deploy.
Could be added the execution of Dependencio as a post hook git, jenkins, etc.



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

