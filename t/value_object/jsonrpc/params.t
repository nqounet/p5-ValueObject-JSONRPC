use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::Params';

subtest 'Params value object' => sub {
  my $a = ValueObject::JSONRPC::Params->new(value => [1, 2, 3]);
  isa_ok $a, ['ValueObject::JSONRPC::Params'];
  ok $a->equals([1, 2, 3]), 'equals arrayref';

  my $h = ValueObject::JSONRPC::Params->new(value => {x => 1});
  ok $h->equals({x => 1}), 'equals hashref';

  like dies { ValueObject::JSONRPC::Params->new(value => 'no') }, qr/JSON-RPC params/, 'reject scalar params';
};

done_testing;
