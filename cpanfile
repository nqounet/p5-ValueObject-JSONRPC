requires 'Moo';
requires 'Moo::Role';
requires 'namespace::clean';
requires 'version';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
    requires 'perl', '5.008_001';
};

on test => sub {
    requires 'Test2::V0';
};
