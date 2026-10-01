use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::ErrorResponse';

subtest 'ErrorResponse' => sub {
  use ValueObject::JSONRPC::ErrorResponse;
  use ValueObject::JSONRPC::Error;
  use ValueObject::JSONRPC::Code;
  use ValueObject::JSONRPC::Id;

  my $code = ValueObject::JSONRPC::Code->new(value => -32600);
  my $err  = ValueObject::JSONRPC::Error->new(
    code    => $code,
    message => 'fail'
  );
  my $id = ValueObject::JSONRPC::Id->new;              # null id allowed
  my $e  = ValueObject::JSONRPC::ErrorResponse->new(
    error => $err,
    id    => $id
  );
  isa_ok $e, ['ValueObject::JSONRPC::ErrorResponse'];

  my $e2 = ValueObject::JSONRPC::ErrorResponse->new(
    error => ValueObject::JSONRPC::Error->new(
      code    => $code,
      message => 'fail'
    ),
    id => ValueObject::JSONRPC::Id->new
  );
  ok $e->equals($e2), 'error responses equal';

  like dies {
    ValueObject::JSONRPC::ErrorResponse->new(
      error  => $err,
      id     => $id,
      result => 1
    )
  }, qr/MUST NOT include a 'result'/, 'reject result in error response';
};

done_testing;
