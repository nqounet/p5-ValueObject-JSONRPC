use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::MethodName';

subtest 'valid method names' => sub {
  my $m = ValueObject::JSONRPC::MethodName->new(value => 'subtract');
  isa_ok $m, [ 'ValueObject::JSONRPC::MethodName' ];
  is $m->value, 'subtract', 'value returns provided method name';
  is "$m", 'subtract', 'stringification returns value';
  ok $m->equals('subtract'), 'equals string value';

  my $m2 = ValueObject::JSONRPC::MethodName->new(value => 'subtract');
  ok $m->equals($m2), 'objects with same value are equal';

  # dotted method names are allowed
  my $d = ValueObject::JSONRPC::MethodName->new(value => 'math.add');
  is $d->value, 'math.add', 'dotted method name allowed';
};

subtest 'invalid method names are rejected' => sub {
  like dies { ValueObject::JSONRPC::MethodName->new(value => '') },
    qr/JSON-RPC method name/, 'empty string rejected';

  like dies { ValueObject::JSONRPC::MethodName->new(value => [] ) },
    qr/JSON-RPC method name/, 'non-scalar rejected';

  like dies { ValueObject::JSONRPC::MethodName->new(value => 'rpc.test') },
    qr/JSON-RPC method name/, 'names starting with "rpc." rejected';

  like dies { ValueObject::JSONRPC::MethodName->new(value => 1 ) },
    qr/JSON-RPC method name/, 'numeric value rejected';
};

done_testing;
