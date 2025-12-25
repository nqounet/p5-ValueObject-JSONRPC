use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::Version';

subtest 'default construction' => sub {
  my $v = ValueObject::JSONRPC::Version->new;
  isa_ok $v, [ 'ValueObject::JSONRPC::Version' ];
  is $v->value, '2.0', 'default value is 2.0';
  is "$v", '2.0', 'stringification returns value';
  ok $v->equals('2.0'), 'equals string value';

  # JSON-RPC 2.0 requires the exact string "2.0" for the jsonrpc member.
  # Ensure other representations or different versions are NOT allowed (must die on construction or not equal).
  ok !$v->equals(2), 'numeric 2 is not equal to "2.0"';
  ok !$v->equals('2'), 'string "2" is not equal to "2.0"';

  # constructing with the exact allowed value '2.0' succeeds
  my $v2 = ValueObject::JSONRPC::Version->new(value => '2.0');
  ok $v->equals($v2), 'objects with same value are equal';

  # equals against a reference that is not same class should be false
  ok !$v->equals([]), 'equals with other ref returns false';

  # equals with undef should be false
  ok !$v->equals(undef), 'equals undef returns false';
};

subtest 'invalid versions are rejected' => sub {
  subtest 'version `2` is rejected' => sub {
    # constructing with a numeric 2 should die because only the exact string '2.0' is allowed
    like dies {ValueObject::JSONRPC::Version->new(value => 2);},
      qr/\QJSON-RPC version MUST be '2.0'\E/;
  };

  subtest 'version `1.0` is rejected' => sub {
    # constructing with a different string like '1.0' should also die
    like dies {ValueObject::JSONRPC::Version->new(value => '1.0');},
      qr/\QJSON-RPC version MUST be '2.0'\E/;
  };

  subtest 'version `[]` is rejected' => sub {
    # constructing with a non-scalar (arrayref) should die because of type constraint
    like dies {ValueObject::JSONRPC::Version->new(value => []);},
      qr/\QJSON-RPC version MUST be '2.0'\E/;
  };
};

done_testing;
