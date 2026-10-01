use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::Params';
use JSON::PP ();    # for JSON::PP::true / false

subtest 'Params value array' => sub {
  my $v = $CLASS->new(value => [1, 2, 3]);
  isa_ok $v, [$CLASS, 'ValueObject::JSONRPC'];
  is $v->value, [1, 2, 3];
  is $v->to_string, q{bless( {value => [1,2,3]}, 'ValueObject::JSONRPC::Params' )};
};

subtest 'Params value object' => sub {
  my $v = $CLASS->new(value => {x => 1});
  isa_ok $v, [$CLASS, 'ValueObject::JSONRPC'];
  is $v->value, {x => 1};
  is $v->to_string, q{bless( {value => {x => 1}}, 'ValueObject::JSONRPC::Params' )};
};

subtest 'Params value scalar' => sub {
  like dies { $CLASS->new(value => 'no') }, qr/did not pass type constraint/, 'reject scalar params';
};

subtest 'Params value null/true/false' => sub {
  my $t = JSON::PP::true;
  my $f = JSON::PP::false;

  # positional (array) params with null, true, false
  my $va = $CLASS->new(value => [undef, $t, $f]);
  isa_ok $va, [$CLASS, 'ValueObject::JSONRPC'];
  is $va->value, [undef, $t, $f];

  # named (object) params with null, true, false
  my $vh = $CLASS->new(
    value => {
      a => undef,
      b => $t,
      c => $f
    }
  );
  isa_ok $vh, [$CLASS, 'ValueObject::JSONRPC'];
  is $vh->value,
    {
    a => undef,
    b => $t,
    c => $f
    };
};

subtest 'Params accept empty array and empty object' => sub {
  my $a = $CLASS->new(value => []);
  isa_ok $a, [$CLASS, 'ValueObject::JSONRPC'];
  is $a->value, +[];
  ok !$a->equals(+[]);

  my $h = $CLASS->new(value => {});
  isa_ok $h, [$CLASS, 'ValueObject::JSONRPC'];
  is $h->value, +{};
  ok !$h->equals(+{});
};

done_testing;
