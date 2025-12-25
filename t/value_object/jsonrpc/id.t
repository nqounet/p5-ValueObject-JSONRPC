use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::Id';

subtest 'Id value object' => sub {
    my $i1 = ValueObject::JSONRPC::Id->new(value => 1);
    isa_ok $i1, ['ValueObject::JSONRPC::Id'];
    is $i1->value, 1;
    ok $i1->equals(1), 'equals numeric';

    my $s = ValueObject::JSONRPC::Id->new(value => 'abc');
    is $s->value, 'abc';
    ok $s->equals('abc');

    my $null = ValueObject::JSONRPC::Id->new;    # undef id (null)
    isa_ok $null, ['ValueObject::JSONRPC::Id'];
    ok !$null->equals(undef), 'equals undef returns false';
};

done_testing;
