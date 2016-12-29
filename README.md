# NAME
Dependencio - Simple utility to find perl cpan modules dependencies recursively in your project.

# INSTALL
better via cpan minus https://metacpan.org/pod/App::cpanminus
once you installed cpanminus type:

cpanm App::Dependencio
now you can use dependencio from your console

# USE EXAMPLE
cd your/project/dir/path
now just type in the console...
dependencio

# DESCRIPTION
Dependencio will scans recursively into your project evaluating all the cpan modules declared, if they are not installed, dependecio will warn you.
if you run 'dependencio -c', automagically will try to install the missing modules via cpanm

To be used as standalone application or as a part of your continuous integration flow.
Could be added the execution of Dependencio as a post hook git, jenkins, etc. If fails returns a non zero output to be properly handled from shell.

## EXPORT
checkDeps

# AUTHOR
dani remeseiro, &lt;jipipayo at cpan dot org&lt;gt>

# COPYRIGHT AND LICENSE
Copyright (C) by dani remeseiro
This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
