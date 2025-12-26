use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::Version';

subtest 'default value' => sub {
  my $v = $CLASS->new;
  isa_ok $v, ['ValueObject::JSONRPC::Version', 'ValueObject::JSONRPC'];
  is $v->value,     '2.0',                                                         'default value is 2.0';
  is $v->to_string, q{bless( {value => '2.0'}, 'ValueObject::JSONRPC::Version' )}, 'to_string returns Dumper format';

  # Value objects must not be equal to plain non-value values (e.g. raw strings).
  ok !$v->equals('2.0'), 'non-value (string) is not equal to value object';

  # equals against a reference that is not same class should be false
  ok !$v->equals([]),          'equals with other ref returns false';
  ok !$v->equals({}),          'equals with other ref returns false';
  ok !$v->equals(sub {'2.0'}), 'equals with other ref returns false';

  # equals with undef should be false
  ok !$v->equals(''),    'equals undef returns false';
  ok !$v->equals(0),     'equals undef returns false';
  ok !$v->equals(undef), 'equals undef returns false';
};

subtest 'valid value' => sub {
  my $v  = $CLASS->new(value => '2.0');
  my $v2 = $CLASS->new(value => '2.0');
  isnt "$v", "$v2", 'different object';
  ok $v->equals($v2), 'objects with same value are equal';
};

subtest 'invalid versions are rejected' => sub {
  like dies { $CLASS->new(value => 2) },     qr/\QJSON-RPC version MUST be '2.0'\E/;
  like dies { $CLASS->new(value => '1.0') }, qr/\QJSON-RPC version MUST be '2.0'\E/;
  like dies { $CLASS->new(value => '') },    qr/\QJSON-RPC version MUST be '2.0'\E/;
  like dies { $CLASS->new(value => undef) }, qr/\QJSON-RPC version MUST be '2.0'\E/;
  like dies { $CLASS->new(value => +[]) },   qr/\QJSON-RPC version MUST be '2.0'\E/;
  like dies { $CLASS->new(value => +{}) },   qr/\QJSON-RPC version MUST be '2.0'\E/;
  like dies {
    $CLASS->new(value => sub {'2.0'})
  }, qr/\QJSON-RPC version MUST be '2.0'\E/;
};

done_testing;
