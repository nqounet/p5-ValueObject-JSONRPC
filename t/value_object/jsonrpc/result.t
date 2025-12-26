use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::Result';

subtest 'Result value object' => sub {
  use ValueObject::JSONRPC::Result;

  my $s = ValueObject::JSONRPC::Result->new(value => 'ok');
  isa_ok $s, ['ValueObject::JSONRPC::Result'];
  is $s->value, 'ok';
  ok $s->equals('ok');

  my $a = ValueObject::JSONRPC::Result->new(value => [1, 2]);
  ok $a->equals([1, 2]), 'equals arrayref';

  my $h = ValueObject::JSONRPC::Result->new(value => {x => 1});
  ok $h->equals({x => 1}), 'equals hashref';

  my $null = ValueObject::JSONRPC::Result->new;    # default undef
  isa_ok $null, ['ValueObject::JSONRPC::Result'];
  ok !$null->equals(undef), 'equals undef returns false';

  like dies { ValueObject::JSONRPC::Result->new(value => \*STDOUT) }, qr/JSON-RPC result/, 'reject non-JSON ref types';
};

done_testing;
