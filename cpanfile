requires 'Moo';
requires 'Scalar::Util';
requires 'Types::Standard';
requires 'namespace::clean';
requires 'parent';
requires 'version';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
    requires 'perl', '5.008_001';
};

on test => sub {
    requires 'JSON::PP';
    requires 'Test2::V0';
};
