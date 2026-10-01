use Test2::V0;
use ValueObject::JSONRPC::Params;
use ValueObject::JSONRPC::MethodName;

my $e = dies { ValueObject::JSONRPC::Params->new(value => 1) };
isa_ok $e, ['ValueObject::JSONRPC::X::InvalidParams'];
is $e->to_error->code->value, -32602, 'params -> -32602';
is $e->to_error->data, "$e", 'message kept in data';

$e = dies { ValueObject::JSONRPC::MethodName->new(value => 'rpc.x') };
isa_ok $e, ['ValueObject::JSONRPC::X::InvalidRequest'];
is $e->to_error->code->value, -32600, 'others -> -32600';
is $e->to_error->message, 'Invalid Request';

is(ValueObject::JSONRPC::X::ParseError->new(message => 'x')->to_error->code->value, -32700);
done_testing;
