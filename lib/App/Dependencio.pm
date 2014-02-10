package App::Dependencio;
use base qw(App::Cmd::Simple);

use strict;
use warnings;
use File::Find;
use Cwd;
use IO::File;
use Term::ANSIColor;
use Module::Load;
our $VERSION = '0.02';



sub opt_spec {
  return (
    [ "testdirs|t",  "exclude dir named t (tests)" ],
    [ "verbose|v",  "verbose output"],
    [ "cpanm|c",  "automatic cpanm install missing modules"],
    [ "help|h",  "this help menu"],
  );
}



sub validate_args {
  my ($self, $opt, $args) = @_;
  $self->usage_error("Bad command") if @$args;
  $self->usage if $opt->{help};
}



sub execute {
  my ($self, $opt, $args) = @_;
  our $opts = $opt;
  $self->checkDeps;
}



sub checkDeps{
    my ($self, $opt) = @_;
    our $cwd  = getcwd();
    my @dirs = ();
    push (@dirs,$cwd);

    find(\&_openFiles, @dirs);
}



sub _openFiles{
    our $opts;
    our $cwd;
    my $dir = $cwd.'/t';
    my $tests = 1;
    if( $dir eq $File::Find::dir and $opts->{testdirs}  ){
       $tests = 0;
    };
    #only open file types to search module declarations (.pm and .pl)
    if(-f && m/\.(pm|pl)$/ and $tests == 1){
        print STDOUT "* checking dependecies on $File::Find::name\n" if $opts->{verbose};
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
                    print STDOUT colored ['bright_red'], "Dependencio says: module $line not found\n";
                    system "cpanm $line" if $opts->{cpanm};
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

