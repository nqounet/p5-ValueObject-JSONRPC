use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::Notification';

# Move commonly used modules out of subtest blocks
use ValueObject::JSONRPC::Notification;
use ValueObject::JSONRPC::MethodName;
use ValueObject::JSONRPC::Params;
use ValueObject::JSONRPC::Id;
use ValueObject::JSONRPC::Version;

subtest 'Notification construction and equality' => sub {
  my $v = ValueObject::JSONRPC::Version->new;
  my $m = ValueObject::JSONRPC::MethodName->new(value => 'notify');
  my $p = ValueObject::JSONRPC::Params->new(value => {x => 1});

  my $n = $CLASS->new(
    jsonrpc => $v,
    method  => $m,
    params  => $p,
  );
  isa_ok $n, [$CLASS, 'ValueObject::JSONRPC'];

  my $n2 = $CLASS->new(
    jsonrpc => $v,
    method  => $m,
    params  => ValueObject::JSONRPC::Params->new(value => {x => 1}),
  );
  ok $n->equals($n2), 'notifications with same content are equal';

  # missing required attributes
  like dies {
    $CLASS->new(
      method => $m,
      params => $p,
    )
  }, qr/Missing required arguments: jsonrpc/, 'constructor rejects missing jsonrpc attribute';

  like dies {
    $CLASS->new(
      jsonrpc => $v,
      params  => $p,
    )
  }, qr/Missing required arguments: method/, 'constructor rejects missing method attribute';

  # params omitted: should be allowed and result in undef params
  my $n3 = $CLASS->new(
    jsonrpc => $v,
    method  => $m,
  );
  isa_ok $n3, [$CLASS, 'ValueObject::JSONRPC'];
  ok !defined $n3->params, 'params is undef when omitted';

};

subtest 'notification must not have an id' => sub {
  like dies {
    $CLASS->new(
      jsonrpc => ValueObject::JSONRPC::Version->new,
      method  => ValueObject::JSONRPC::MethodName->new(value => 'foo'),
      id      => 1,
    )
  }, qr/MUST NOT include an 'id'/, 'id rejected';
};

done_testing;
