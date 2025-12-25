requires 'perl', '5.008001';

requires 'Moo', '2';
requires 'namespace::clean', '0';

on 'test' => sub {
  requires 'Test2::V0', '0';
};
