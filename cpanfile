requires 'perl', '5.008001';

requires 'Moo', '2';
requires 'Types::Standard', '1';

on 'test' => sub {
    requires 'Test2::V0', '0';
    requires 'Test2::Tools::Exception', '0';
};
