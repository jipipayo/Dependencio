package App::Dependencio;
use base qw(App::Cmd::Simple);
use strict;
use warnings;
use File::Find;
use IO::File;
use Cwd;
use Data::Printer;
use Term::ANSIColor;
use Module::Extract::Use;
use Module::CPANfile;

our $VERSION = '0.10';
my $cwd;
my $opts;
my @mods_required = ();
my @mods_not_found = ();


sub opt_spec {
    return (
        [ "testdirs|t",  "Exclude dir named t (tests)" ],
        [ "verbose|v",  "Verbose output"],
        [ "install|i",  "Automatic installs all the missing modules via cpanm"],
        [ "cpanfile|c",  "Reads if exists a cpanfile in the root dir of your project and checks if are installed.
            \n Checks if the modules required are included on this cpanfile"],
        [ "help|h",  "This help menu. (i am dependencio version $VERSION)"],
    );
}


sub validate_args {
    my ($self, $opt, $args) = @_;
    $self->usage_error("Bad command") if @$args;
    $self->usage if $opt->{help};
}


sub execute {
    my ($self, $opt, $args) = @_;
    $opts = $opt;
    $self->checkDeps;
}


sub checkDeps{
    my ($self, $opt) = @_;
    $cwd  = getcwd();
    $self->_detect_cpanfile if $opts->{cpanfile};
    my @dirs = ();
    push (@dirs,$cwd);

    print STDOUT colored ['bright_blue'], "Searching modules dependencies recursively from $cwd \n";
    find(\&_scan_files, @dirs);

    foreach my $mod_not_found (@mods_not_found){
        print STDOUT colored ['bright_red'], "module $mod_not_found not found\n";
        system "cpanm $mod_not_found" if $opts->{install};

    }

    exit -1 if @mods_not_found or print STDOUT colored ['bright_green'], "success! all dependencies met...\n";
}


sub _detect_cpanfile{
    my ($self) = @_;
    my $cpanfile = $cwd.'/cpanfile';
    if(-f $cpanfile){
        print STDOUT colored ['bright_yellow'], "cpanfile found on $cwd/cpanfile \n";
        $self->_parse_cpanfile(@mods_not_found, @mods_required, $cpanfile);
    } else {
        print STDOUT colored ['bright_white'], "cpanfile NOT found on $cwd/cpanfile \n";
    }
}


sub _parse_cpanfile{
    my ($self,$cpanfile) = @_;
    my $filec = IO::File->new($cpanfile, O_RDONLY) or die 'I can not open file ', $cpanfile, ": $!";

    while ( my $line = $filec->getline() ){
            $line=~ s/\'([^']*)\'/$1/m;
            $line=~s/^\s+//;
            $line=~s/;//;
            while( $line =~ m/requires/g ){
                $line =~ s/requires //;
                print STDOUT $line;
            }
    }
}


sub _scan_files{
    my $dir = $cwd.'/t';
    my $tests = 1;
    if( $dir eq $File::Find::dir and $opts->{testdirs} ){ $tests = 0; };

    #only open file types to search module declarations (.pm and .pl)
    if(-f && m/\.(pm|pl)$/ and $tests == 1){
        print STDOUT "* checking dependecies on $File::Find::name\n" if $opts->{verbose};
        my $file = $File::Find::name;

        my $extractor = Module::Extract::Use->new;
        @mods_required = $extractor->get_modules($file);

        foreach my $module  (@mods_required) {
            if($module =~ /\p{Uppercase}/){ #do not eval things like "warnings","strict",etc (at least one uppercase)
                print STDOUT colored ['bright_green'], "required module $module found\n" if $opts->{verbose};
                my $path = $module. ".pm";
                $path =~ s{::}{/}g;
                eval {require $path } or
                do {
                   my $error = $@;
                   push( @mods_not_found, $module) unless grep{$_ eq $module} @mods_not_found;
                }
            }

        }
    }
}
1;



__END__

=head1 NAME

Dependencio - Simple utility to find perl cpan modules dependencies recursively in your project.


=head1 SYNOPSIS
cd yourawesemeproject
now just type in the console...
dependencio



=head1 DESCRIPTION
Dependencio will scans recursively into your project evaluating all the cpan modules declared, if they are not installed, dependecio will warn you.
if you run 'dependencio -c', automagically will try to install the missing modules via cpanm

To be used as standalone application or as a part of your continuous integration flow.
Could be added the execution of Dependencio as a post hook git, jenkins, etc. If fails returns a non zero output to be properly handled from shell.



=head2 EXPORT

checkDeps


=head1 AUTHOR

dani remeseiro, E<lt>jipipayo at cpan dot org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) by dani remeseiro
This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

