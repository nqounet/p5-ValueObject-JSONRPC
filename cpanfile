requires 'JSON::PP';
requires 'Moo';
requires 'Scalar::Util';
requires 'Types::Standard';
requires 'namespace::clean';
requires 'parent';
requires 'version';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
    requires 'perl', '5.010';
};

on test => sub {
    requires 'Test2::V0';
};
