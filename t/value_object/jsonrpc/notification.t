use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::Notification';

subtest 'Notification construction and equality' => sub {
    use ValueObject::JSONRPC::Notification;
    use ValueObject::JSONRPC::MethodName;
    use ValueObject::JSONRPC::Params;
    use ValueObject::JSONRPC::Id;

    my $m = ValueObject::JSONRPC::MethodName->new(value => 'notify');
    my $p = ValueObject::JSONRPC::Params->new(value => {x => 1});

    my $n = ValueObject::JSONRPC::Notification->new(
        method => $m,
        params => $p
    );
    isa_ok $n, ['ValueObject::JSONRPC::Notification'];

    my $n2 = ValueObject::JSONRPC::Notification->new(
        method => $m,
        params => ValueObject::JSONRPC::Params->new(value => {x => 1})
    );
    ok $n->equals($n2), 'notifications with same content are equal';

    # constructor should reject unknown/forbidden attributes like `id`
    like dies {
        ValueObject::JSONRPC::Notification->new(
            method => $m,
            id     => ValueObject::JSONRPC::Id->new(value => 1)
        )
    }, qr/JSON-RPC notification MUST NOT include/,
      'notification rejects id attribute';
};

done_testing;
