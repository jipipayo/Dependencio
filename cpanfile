requires 'perl', '5.008001';

requires 'File::Find';
requires 'Cwd';
requires 'IO::File';
requires 'Term::ANSIColor';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

