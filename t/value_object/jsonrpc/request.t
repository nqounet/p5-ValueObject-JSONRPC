use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::Request';

subtest 'Request construction and equality' => sub {
  use ValueObject::JSONRPC::Version;
  use ValueObject::JSONRPC::MethodName;
  use ValueObject::JSONRPC::Params;
  use ValueObject::JSONRPC::Id;

  my $v  = ValueObject::JSONRPC::Version->new;
  my $m  = ValueObject::JSONRPC::MethodName->new(value => 'sum');
  my $p  = ValueObject::JSONRPC::Params->new(value => [1, 2]);
  my $id = ValueObject::JSONRPC::Id->new(value => 42);

  my $r = $CLASS->new(
    jsonrpc => $v,
    method  => $m,
    params  => $p,
    id      => $id,
  );
  isa_ok $r, [$CLASS, 'ValueObject::JSONRPC'];

  # equals with another object
  my $r2 = $CLASS->new(
    jsonrpc => $v,
    method  => $m,
    params  => $p,
    id      => ValueObject::JSONRPC::Id->new(value => 42),
  );
  ok $r->equals($r2), 'requests with same content are equal';

  # Missing `id`
  like dies {
    $CLASS->new(
      jsonrpc => $v,
      method  => $m,
      params  => $p,
    )
  }, qr/Missing required arguments: id/, 'request without id rejected';

  # id => null
  ok lives {
    $CLASS->new(
      jsonrpc => $v,
      method  => $m,
      params  => $p,
      id      => ValueObject::JSONRPC::Id->new,
    )
  };
};

done_testing;
