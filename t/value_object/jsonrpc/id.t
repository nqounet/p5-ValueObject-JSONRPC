use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::Id';
use JSON::PP ();    # for JSON::PP::true / false

subtest 'default value' => sub {
  my $v = $CLASS->new;
  isa_ok $v, [$CLASS, 'ValueObject::JSONRPC'];
  is $v->value,     undef,                                                    'default value is undef';
  is $v->to_string, q{bless( {value => undef}, 'ValueObject::JSONRPC::Id' )}, 'to_string returns Dumper format';
  ok !$v->equals(undef), 'not equals non value object';
};

subtest 'valid value' => sub {
  subtest 'value is string' => sub {
    my $v = $CLASS->new(value => 'abc');
    isa_ok $v, [$CLASS, 'ValueObject::JSONRPC'];
    is $v->value, 'abc';
    is $v->to_string, q{bless( {value => 'abc'}, 'ValueObject::JSONRPC::Id' )}, 'to_string returns Dumper format';
    ok !$v->equals('abc'), 'not equals non value object';

    my $v2 = $CLASS->new(value => 'abc');
    isnt "$v", "$v2", 'are different objects (compare reference hash values)';
    ok $v->equals($v2), 'value objects with the same value are equal';
  };

  subtest 'value is integer' => sub {
    my $v = $CLASS->new(value => 1);
    isa_ok $v, [$CLASS, 'ValueObject::JSONRPC'];
    is $v->value, 1;
    is $v->to_string, q{bless( {value => 1}, 'ValueObject::JSONRPC::Id' )}, 'to_string returns Dumper format';
  };

  subtest 'value is empty' => sub {
    my $v = $CLASS->new(value => '');
    isa_ok $v, [$CLASS, 'ValueObject::JSONRPC'];
    is $v->value, '';
  };

  subtest 'value is 0' => sub {
    my $v = $CLASS->new(value => 0);
    isa_ok $v, [$CLASS, 'ValueObject::JSONRPC'];
    is $v->value, 0;
  };

  subtest 'value is undef' => sub {
    my $v = $CLASS->new(value => undef);
    isa_ok $v, [$CLASS, 'ValueObject::JSONRPC'];
    is $v->value, undef;
  };

  # === Additional tests requested ===
  subtest 'string vs number distinct' => sub {
    my $num = $CLASS->new(value => 1);
    my $str = $CLASS->new(value => '1');
    is $num->to_string, q{bless( {value => 1}, 'ValueObject::JSONRPC::Id' )},   'to_string returns Dumper format';
    is $str->to_string, q{bless( {value => '1'}, 'ValueObject::JSONRPC::Id' )}, 'to_string returns Dumper format';
    ok !$num->equals($str), 'number 1 is not equal to string "1"';
  };

  subtest 'negative number' => sub {
    my $v = $CLASS->new(value => -1);
    isa_ok $v, [$CLASS, 'ValueObject::JSONRPC'];
    is $v->value, -1;
  };

  subtest 'float and exponent' => sub {
    my $f = $CLASS->new(value => 1.5);
    is $f->value, 1.5;
    my $e = $CLASS->new(value => 1e10);
    is $e->value, 1e10;

    # equals check for floats
    ok $CLASS->new(value => 1.5)->equals($CLASS->new(value => 1.5)), 'floats with same numeric value are equal';
  };

  subtest 'empty vs space' => sub {
    my $empty = $CLASS->new(value => '');
    is $empty->value, '';
    my $space = $CLASS->new(value => ' ');
    is $space->value, ' ';
    ok !$empty->equals($space), 'empty string is not equal to a space string';
  };

  subtest 'unicode and emoji' => sub {
    my $u = $CLASS->new(value => 'あいうえお');
    is $u->value, 'あいうえお';
    my $emoji = $CLASS->new(value => '🔥');
    is $emoji->value, '🔥';
  };

  subtest 'numeric equals behavior' => sub {
    ok $CLASS->new(value  => 1)->equals($CLASS->new(value => 1)),   'same numeric values are equal';
    ok !$CLASS->new(value => 1)->equals($CLASS->new(value => '1')), 'numeric and string with same characters are not equal';
  };
};

subtest 'invalid versions are rejected' => sub {
  like dies { $CLASS->new(value => +[]) }, qr/JSON-RPC id MUST be a String, Number, or null/;
  like dies { $CLASS->new(value => +{}) }, qr/JSON-RPC id MUST be a String, Number, or null/;
  like dies {
    $CLASS->new(value => sub {undef})
  }, qr/JSON-RPC id MUST be a String, Number, or null/;

  subtest 'boolean values are rejected' => sub {
    my $true  = JSON::PP::true;
    my $false = JSON::PP::false;
    like dies { $CLASS->new(value => $true) },  qr/JSON-RPC id MUST be a String, Number, or null/;
    like dies { $CLASS->new(value => $false) }, qr/JSON-RPC id MUST be a String, Number, or null/;
  };
};

done_testing;
