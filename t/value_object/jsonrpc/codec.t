use strict;
use warnings;
use Test2::V0;
use JSON::PP ();
use File::Basename qw(basename);

use ValueObject::JSONRPC::Codec;

my $codec = ValueObject::JSONRPC::Codec->new;
my $PKG   = 'ValueObject::JSONRPC';
my $json  = JSON::PP->new->canonical;

# 値が同じ JSON か（空白・キー順の違いは無視）
sub same { $json->encode($json->decode($_[0])) eq $json->encode($json->decode($_[1])) }

sub x_of {
  my ($text) = @_;
  my $r = eval { $codec->decode($text) };
  return $@ || fail("expected an exception, got $r");
}

subtest 'spec examples: single messages round-trip' => sub {
  for my $t (
    ['Request positional',   '{"jsonrpc":"2.0","method":"subtract","params":[42,23],"id":1}',             'Request'],
    ['Request named',        '{"jsonrpc":"2.0","method":"subtract","params":{"subtrahend":23,"minuend":42},"id":3}', 'Request'],
    ['Notification',         '{"jsonrpc":"2.0","method":"update","params":[1,2,3,4,5]}',                  'Notification'],
    ['Notification no params', '{"jsonrpc":"2.0","method":"foobar"}',                                       'Notification'],
    ['SuccessResponse',      '{"jsonrpc":"2.0","result":19,"id":1}',                                       'SuccessResponse'],
    ['ErrorResponse',        '{"jsonrpc":"2.0","error":{"code":-32601,"message":"Method not found"},"id":"1"}', 'ErrorResponse'],
    ['ErrorResponse null id', '{"jsonrpc":"2.0","error":{"code":-32700,"message":"Parse error"},"id":null}', 'ErrorResponse'],
    ['ErrorResponse data',   '{"jsonrpc":"2.0","error":{"code":1,"message":"m","data":{"a":[1]}},"id":1}', 'ErrorResponse'],
    ['result null',          '{"jsonrpc":"2.0","result":null,"id":1}',                                     'SuccessResponse'],
  ) {
    my ($name, $text, $class) = @$t;
    my $m = $codec->decode($text);
    isa_ok $m, ["${PKG}::$class"], $name;
    ok same($codec->encode($m), $text), "$name round-trips";
  }
};

subtest 'id keeps string vs number' => sub {
  my $s = $codec->decode('{"jsonrpc":"2.0","method":"m","id":"1"}');
  my $n = $codec->decode('{"jsonrpc":"2.0","method":"m","id":1}');
  like $codec->encode($s), qr/"id":"1"/, 'string id stays string';
  like $codec->encode($n), qr/"id":1\b/, 'number id stays number';
};

subtest 'spec examples: invalid input' => sub {
  isa_ok x_of('{"jsonrpc":"2.0","method":"foobar,"params":"bar","baz]'), ["${PKG}::X::ParseError"], 'parse error';
  isa_ok x_of('{"jsonrpc":"2.0","method":1,"params":"bar"}'),            ["${PKG}::X::InvalidRequest"], 'method not a string';
  isa_ok x_of('{"jsonrpc":"2.0","method":"foo","params":"bar","id":1}'), ["${PKG}::X::InvalidParams"],  'params not structured';
  isa_ok x_of('{"method":"foo","id":1}'),                                ["${PKG}::X::InvalidRequest"], 'jsonrpc missing';
  isa_ok x_of('{"jsonrpc":"1.0","method":"foo","id":1}'),                ["${PKG}::X::InvalidRequest"], 'jsonrpc 1.0';
  isa_ok x_of('{"jsonrpc":"2.0","method":"foo","id":null}'),             ["${PKG}::X::InvalidRequest"], 'request id null';
  isa_ok x_of('{"jsonrpc":"2.0","result":1,"error":{"code":1,"message":"m"},"id":1}'), ["${PKG}::X::InvalidRequest"], 'result and error';
  isa_ok x_of('{"jsonrpc":"2.0","result":1}'),                           ["${PKG}::X::InvalidRequest"], 'response without id';
  isa_ok x_of('{"jsonrpc":"2.0","error":{"code":"1","message":"m"},"id":1}'), ["${PKG}::X::InvalidRequest"], 'string error code';
  isa_ok x_of('1'),                                                       ["${PKG}::X::InvalidRequest"], 'scalar';
  isa_ok x_of('[]'),                                                      ["${PKG}::X::InvalidRequest"], 'empty batch';
  isa_ok x_of(''),                                                        ["${PKG}::X::ParseError"],     'empty text';
  isa_ok x_of(undef),                                                     ["${PKG}::X::ParseError"],     'undef';
  is x_of('{"jsonrpc":"2.0","method":"foo","id":1,"params":1}')->to_error->code->value, -32602, 'to_error bridge';
};

subtest 'spec example: batch with invalid elements' => sub {
  my $r = $codec->decode(<<'J');
[
  {"jsonrpc":"2.0","method":"sum","params":[1,2,4],"id":"1"},
  {"jsonrpc":"2.0","method":"notify_hello","params":[7]},
  {"foo":"boo"},
  {"jsonrpc":"2.0","method":"foo.get","params":{"name":"myself"},"id":"5"},
  1
]
J
  is ref $r, 'ARRAY', 'array';
  isa_ok $r->[0], ["${PKG}::Request"];
  isa_ok $r->[1], ["${PKG}::Notification"];
  isa_ok $r->[2], ["${PKG}::X::InvalidRequest"];
  isa_ok $r->[3], ["${PKG}::Request"];
  isa_ok $r->[4], ["${PKG}::X::InvalidRequest"];

  my @ok = grep { !$_->isa("${PKG}::X") } @$r;
  ok same($codec->encode(\@ok),
    '[{"jsonrpc":"2.0","method":"sum","params":[1,2,4],"id":"1"},{"jsonrpc":"2.0","method":"notify_hello","params":[7]},{"jsonrpc":"2.0","method":"foo.get","params":{"name":"myself"},"id":"5"}]'),
    'batch encodes as array';
};

subtest 'json implementation is replaceable' => sub {
  my $c = ValueObject::JSONRPC::Codec->new(json => JSON::PP->new);
  my $text = '{"jsonrpc":"2.0","method":"m"}';
  ok same($c->encode($c->decode($text)), $text), 'works';    # 非 canonical なのでキー順は不定
};

# json-rpc-2.0-exercises の tests/（happy / edge / malicious）
subtest 'exercises fixtures' => sub {
  my $n = 0;
  for my $file (sort glob 't/data/exercises/*/*.json') {
    open my $fh, '<:raw', $file or die "$file: $!";
    my $text = do { local $/; <$fh> };
    my $m = eval { $codec->decode($text) };
    if (my $x = $@) {
      ok $x->isa("${PKG}::X"), basename(dirname_of($file)) . '/' . basename($file) . ' -> X';
      next;
    }
    $n++;
    if (ref $m eq 'ARRAY' && grep { $_->isa("${PKG}::X") } @$m) {
      pass "$file decodes per element";    # 不正な要素を含む batch は encode できない
      next;
    }
    ok same($codec->encode($m), $text), $file . ' round-trips';
  }
  ok $n > 100, "decoded $n fixtures";
};

sub dirname_of { (my $p = $_[0]) =~ s{/[^/]+$}{}; $p }

done_testing;
