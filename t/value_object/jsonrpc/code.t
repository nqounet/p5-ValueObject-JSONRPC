use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::Code';

subtest '引数なしで生成する' => sub {
  like dies { $CLASS->new }, qr/Missing required arguments: value/;
};

subtest 'Code value object' => sub {
  my $v = $CLASS->new(value => -32600);
  isa_ok $v, [$CLASS, 'ValueObject::JSONRPC'];
  is $v->value, -32600;
  ok !$v->equals(-32600), '値と値オブジェクトはイコールではない';

  like dies { ValueObject::JSONRPC::Code->new(value => 'no') }, qr/JSON-RPC code MUST be an integer/,
    'reject non-integer codes';
  like dies { $CLASS->new(value => 1.5) }, qr/JSON-RPC code MUST be an integer/, 'reject float codes';

  # 新方針: 必ず数値だけを許容する -> 数字文字列は拒絶
  like dies { $CLASS->new(value => '123') }, qr/JSON-RPC code MUST be an integer/, 'reject numeric string codes';
  like dies { $CLASS->new(value => '01') },  qr/JSON-RPC code MUST be an integer/, 'reject leading-zero numeric string codes';

  # refs / undef は拒絶
  like dies { $CLASS->new(value => []) }, qr/JSON-RPC code MUST be an integer, got ref/;
  like dies { $CLASS->new(value => undef) }, qr/JSON-RPC code MUST be an integer/, 'reject undef';

  # 値オブジェクト同士の比較: 同じ値なら equal, 異なる値なら not equal
  my $v_same = $CLASS->new(value => -32600);
  isnt "$v", "$v_same", 'different object instances (different refs)';
  ok $v->equals($v_same), '同じクラス・同じ値の値オブジェクトは equal';

  my $v_diff = $CLASS->new(value => -32000);
  ok !$v->equals($v_diff), '同じクラスでも値が異なれば not equal';
};

subtest 'accept standard JSON-RPC codes' => sub {
  for my $c (-32700, -32600, -32601, -32602, -32603) {
    my $v = $CLASS->new(value => $c);
    is $v->value, $c, "accept $c";
  }
};

subtest 'big integers accepted as numeric scalars' => sub {

  # 文字列ではなく数値として与えることが前提
  my $big = $CLASS->new(value => 2**60);
  is $big->value, 2**60, 'accept big integer numeric scalar';
};

done_testing;
