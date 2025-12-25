use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::Request';

subtest 'Request construction and equality' => sub {
    use ValueObject::JSONRPC::Request;
    use ValueObject::JSONRPC::MethodName;
    use ValueObject::JSONRPC::Params;
    use ValueObject::JSONRPC::Id;

    my $m  = ValueObject::JSONRPC::MethodName->new(value => 'sum');
    my $p  = ValueObject::JSONRPC::Params->new(value => [1, 2]);
    my $id = ValueObject::JSONRPC::Id->new(value => 42);

    my $r = ValueObject::JSONRPC::Request->new(
        method => $m,
        params => $p,
        id     => $id
    );
    isa_ok $r, ['ValueObject::JSONRPC::Request'];

    # equals with another object
    my $r2 = ValueObject::JSONRPC::Request->new(
        method => $m,
        params => $p,
        id     => ValueObject::JSONRPC::Id->new(value => 42)
    );
    ok $r->equals($r2), 'requests with same content are equal';

    like
      dies { ValueObject::JSONRPC::Request->new(method => $m, params => $p) },
      qr/JSON-RPC request id|Missing required arguments/,
      'request without id rejected';

    # id null (Id with undef) should be rejected for Request
    like dies {
        ValueObject::JSONRPC::Request->new(
            method => $m,
            params => $p,
            id     => ValueObject::JSONRPC::Id->new
        )
    }, qr/JSON-RPC request id MUST NOT be null/,
      'request with null id rejected';
};

done_testing;
