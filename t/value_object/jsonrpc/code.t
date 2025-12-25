use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::Code';

subtest 'Code value object' => sub {
    my $c = ValueObject::JSONRPC::Code->new(value => -32600);
    isa_ok $c, ['ValueObject::JSONRPC::Code'];
    is $c->value, -32600;
    ok $c->equals(-32600);

    like dies { ValueObject::JSONRPC::Code->new(value => 'no') },
      qr/JSON-RPC code/, 'reject non-integer codes';
};

done_testing;
