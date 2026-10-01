use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::SuccessResponse';

subtest 'SuccessResponse' => sub {
  use ValueObject::JSONRPC::SuccessResponse;
  use ValueObject::JSONRPC::Result;
  use ValueObject::JSONRPC::Id;

  my $res = ValueObject::JSONRPC::Result->new(value => 'ok');
  my $id  = ValueObject::JSONRPC::Id->new(value => 1);
  my $s   = ValueObject::JSONRPC::SuccessResponse->new(
    result => $res,
    id     => $id
  );
  isa_ok $s, ['ValueObject::JSONRPC::SuccessResponse'];

  my $s2 = ValueObject::JSONRPC::SuccessResponse->new(
    result => ValueObject::JSONRPC::Result->new(value => 'ok'),
    id     => ValueObject::JSONRPC::Id->new(value => 1)
  );
  ok $s->equals($s2), 'success responses equal';

  like dies {
    ValueObject::JSONRPC::SuccessResponse->new(
      result => $res,
      id     => $id,
      error  => 1
    )
  }, qr/NOT include an 'error'/, 'reject error in success response';
};

done_testing;
