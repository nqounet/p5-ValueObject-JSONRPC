use strict;
use Test2::V0 -target => 'ValueObject::JSONRPC::MethodName';
use JSON::PP ();    # for JSON::PP::true / false

subtest 'default value' => sub {
  like dies { $CLASS->new }, qr/Missing required arguments: value/;
};

subtest 'valid value' => sub {
  my $m = $CLASS->new(value => 'subtract');
  isa_ok $m, [$CLASS, 'ValueObject::JSONRPC'];
  is $m->value, 'subtract', 'value returns provided method name';
  ok !$m->equals('subtract'), 'value objects are not equal to raw strings';

  my $m2 = $CLASS->new(value => 'subtract');
  ok $m->equals($m2), 'objects with same value are equal';

  # dotted method names are allowed
  my $d = $CLASS->new(value => 'math.add');
  is $d->value, 'math.add', 'dotted method name allowed';
  ok !$m->equals($d);
};

subtest 'invalid method names are rejected' => sub {
  like dies { $CLASS->new(value => '') }, qr/did not pass type constraint/, 'empty string rejected';

  like dies { $CLASS->new(value => +[]) },             qr/did not pass type constraint/, 'array rejected';
  like dies { $CLASS->new(value => +{}) },             qr/did not pass type constraint/, 'hash rejected';
  like dies { $CLASS->new(value => JSON::PP::true) },  qr/did not pass type constraint/, 'true rejected';
  like dies { $CLASS->new(value => JSON::PP::false) }, qr/did not pass type constraint/, 'false rejected';

  like dies { $CLASS->new(value => 'rpc.test') }, qr/did not pass type constraint/, 'names starting with "rpc." rejected';

  ok lives { $CLASS->new(value => 1) },   'numeric value';
  ok lives { $CLASS->new(value => '1') }, 'numeric like value';
};

subtest 'leading/trailing whitespace' => sub {
  ok lives { $CLASS->new(value => ' foo') },  'leading space';
  ok lives { $CLASS->new(value => "foo\t") }, 'trailing tab';
  ok lives { $CLASS->new(value => "\nfoo") }, 'leading newline';
};

subtest 'dot edge cases' => sub {
  ok lives { $CLASS->new(value => '.foo') }, 'leading dot';
  ok lives { $CLASS->new(value => 'foo.') }, 'trailing dot';
  ok lives { $CLASS->new(value => 'a..b') }, 'empty segment (consecutive dots)';
};

subtest 'control characters' => sub {
  ok lives { $CLASS->new(value => "foo\x00bar") }, 'NUL';
  ok lives { $CLASS->new(value => "foo\nbar") },   'newline in the middle';
};

subtest 'unicode and emoji allowed' => sub {
  my $u = $CLASS->new(value => 'メソッド名');
  is $u->value, 'メソッド名', 'unicode allowed';

  my $e = $CLASS->new(value => "add💥");
  is $e->value, "add💥", 'emoji allowed (if implementation permits)';
};

# stringified objects: most implementations should reject non-scalar refs even if stringifiable
{

  package _S_ONG;
  use overload
    '""'     => sub { ${$_[0]} },
    fallback => 1;

  sub new {
    my $tmp = $_[1] || '';
    bless \$tmp, __PACKAGE__;
  }
}
subtest 'stringified objects rejected' => sub {
  like dies { $CLASS->new(value => _S_ONG->new('foo')) }, qr/did not pass type constraint/,
    'stringified objects rejected (should be plain scalars)';
};

subtest 'equals symmetry and types' => sub {
  my $first  = $CLASS->new(value => 'subtract');
  my $second = $CLASS->new(value => 'subtract');
  ok $first->equals($second) && $second->equals($first), 'equals is symmetric';

  ok !$first->equals('subtract'), 'object != raw string';
};

subtest 'MethodName accepts whitespace-only string (explicit)' => sub {
  my $m = $CLASS->new(value => "  ");
  isa_ok $m, [$CLASS, 'ValueObject::JSONRPC'];
  is $m->value, "  ", 'whitespace-only string retained as value';
  ok !$m->equals("  "), 'value objects are not equal to raw strings';
};

done_testing;
