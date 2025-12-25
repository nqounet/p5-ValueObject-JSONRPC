use strict;
use Test2::V0;

subtest 'edge cases' => sub {
    use ValueObject::JSONRPC::Id;
    use ValueObject::JSONRPC::Code;
    use ValueObject::JSONRPC::Error;
    use ValueObject::JSONRPC::Result;
    use ValueObject::JSONRPC::Params;
    use ValueObject::JSONRPC::MethodName;
    use ValueObject::JSONRPC::Request;

    subtest 'Id rejects references' => sub {
        like dies { ValueObject::JSONRPC::Id->new(value => []) },
          qr/JSON-RPC id/, 'arrayref id rejected';
        like dies { ValueObject::JSONRPC::Id->new(value => {}) },
          qr/JSON-RPC id/, 'hashref id rejected';
    };

    subtest 'Code accepts numeric strings and equals numeric' => sub {
        my $c = ValueObject::JSONRPC::Code->new(value => '1');
        isa_ok $c, ['ValueObject::JSONRPC::Code'];
        ok $c->equals(1), 'string "1" equals numeric 1';
    };

    subtest 'Error data accepts JSON values and compares deeply' => sub {
        my $code = ValueObject::JSONRPC::Code->new(value => -32000);

        my $d1 = [1, {x => [2, 3]}, 's'];
        my $e1 = ValueObject::JSONRPC::Error->new(
            code    => $code,
            message => 'm',
            data    => $d1
        );
        my $d2 = [1, {x => [2, 3]}, 's'];
        my $e2 = ValueObject::JSONRPC::Error->new(
            code    => $code,
            message => 'm',
            data    => $d2
        );
        ok $e1->equals($e2), 'errors with equivalent arrayref data are equal';

        my $e3 = ValueObject::JSONRPC::Error->new(
            code    => $code,
            message => 'm',
            data    => 'scalar'
        );
        my $e4 = ValueObject::JSONRPC::Error->new(
            code    => $code,
            message => 'm',
            data    => 'scalar'
        );
        ok $e3->equals($e4), 'errors with same scalar data are equal';
    };

    subtest 'Result deep equality with nested structures' => sub {
        my $r1
          = ValueObject::JSONRPC::Result->new(value => {a => [1, {b => 2}]});
        my $r2
          = ValueObject::JSONRPC::Result->new(value => {a => [1, {b => 2}]});
        ok $r1->equals($r2),
          'results with equivalent nested structures are equal';

        ok $r1->equals({a => [1, {b => 2}]}), 'compare result to raw hashref';
    };

    subtest 'Params accept empty array and empty object' => sub {
        my $a = ValueObject::JSONRPC::Params->new(value => []);
        isa_ok $a, ['ValueObject::JSONRPC::Params'];
        ok $a->equals([]), 'empty arrayref accepted and equals';

        my $h = ValueObject::JSONRPC::Params->new(value => {});
        isa_ok $h, ['ValueObject::JSONRPC::Params'];
        ok $h->equals({}), 'empty hashref accepted and equals';
    };

    subtest 'MethodName accepts whitespace-only string (explicit)' => sub {
        my $m = ValueObject::JSONRPC::MethodName->new(value => "  ");
        isa_ok $m, ['ValueObject::JSONRPC::MethodName'];
        is $m->value, "  ", 'whitespace-only string retained as value';
        ok $m->equals("  ");
    };

    subtest 'Request rejects raw scalar id (must be Id instance)' => sub {
        my $m = ValueObject::JSONRPC::MethodName->new(value => 'sum');
        my $p = ValueObject::JSONRPC::Params->new(value => [1, 2]);

        like dies {
            ValueObject::JSONRPC::Request->new(
                method => $m,
                params => $p,
                id     => 1
            )
        }, qr/JSON-RPC request id must be a ValueObject::JSONRPC::Id/,
          'raw numeric id rejected';
        like dies {
            ValueObject::JSONRPC::Request->new(
                method => $m,
                params => $p,
                id     => 'x'
            )
        }, qr/JSON-RPC request id must be a ValueObject::JSONRPC::Id/,
          'raw string id rejected';
        like dies {
            ValueObject::JSONRPC::Request->new(
                method => $m,
                params => $p,
                id     => []
            )
        }, qr/JSON-RPC request id must be a ValueObject::JSONRPC::Id/,
          'ref id rejected';
    };

};

done_testing;
