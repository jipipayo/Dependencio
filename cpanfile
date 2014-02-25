requires 'perl', '5.008001';

requires 'File::Find';
requires 'Cwd';
requires 'IO::File';
requires 'Term::ANSIColor';
requires 'App::Cmd::Simple';
requires 'Text::Trim';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

