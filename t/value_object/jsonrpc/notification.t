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

subtest 'Notification to_json' => sub {

  my $v = ValueObject::JSONRPC::Version->new;
  my $m = ValueObject::JSONRPC::MethodName->new(value => 'notify');
  my $p = ValueObject::JSONRPC::Params->new(value => {x => 1});

  # with params
  my $n = $CLASS->new(
    jsonrpc => $v,
    method  => $m,
    params  => $p,
  );
  my $json_with_params = $n->to_json;
  is $json_with_params->{jsonrpc}, $v->value, 'to_json includes jsonrpc value';
  is $json_with_params->{method},  $m->value, 'to_json includes method value';
  ok exists $json_with_params->{params},         'to_json includes params when present';
  ok ref($json_with_params->{params}) eq 'HASH', 'params is a hashref';
  is $json_with_params->{params}->{x}, 1, 'params value is preserved in to_json';

  # without params
  my $n3 = $CLASS->new(
    jsonrpc => $v,
    method  => $m,
  );
  my $json_no_params = $n3->to_json;
  is $json_no_params->{jsonrpc}, $v->value, 'to_json includes jsonrpc value';
  is $json_no_params->{method},  $m->value, 'to_json includes method value';
  ok !exists $json_no_params->{params}, 'to_json does not include params when omitted';

};

done_testing;
