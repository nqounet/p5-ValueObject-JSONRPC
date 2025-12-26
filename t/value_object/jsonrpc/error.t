use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::Error';

subtest 'Error value object' => sub {
  use ValueObject::JSONRPC::Code;

  my $code = ValueObject::JSONRPC::Code->new(value => -32601);
  my $err  = ValueObject::JSONRPC::Error->new(
    code    => $code,
    message => 'Method not found'
  );
  isa_ok $err, ['ValueObject::JSONRPC::Error'];
  is $err->code->value, -32601;
  is $err->message,     'Method not found';

  like dies { ValueObject::JSONRPC::Error->new(code => -1, message => '') }, qr/JSON-RPC error/,
    'reject invalid error construction';
};

done_testing;
