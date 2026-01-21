package ValueObject::JSONRPC::MethodName;
use strict;
use warnings;
use parent 'ValueObject::JSONRPC';

use Moo;
use Types::Standard qw(Str);
use Scalar::Util    qw(looks_like_number blessed);
use namespace::clean;

has 'value' => (
  is       => 'ro',
  required => 1,
  isa      => Str->where(
    sub {
      # must be non-empty
      return 0 unless length $_ > 0;

      # reject names starting with 'rpc.'
      return 0 if $_ =~ /\Arpc\./;

      return 1;
    }
  ),
);

1;
__END__

=encoding utf-8

=head1 NAME

ValueObject::JSONRPC::MethodName — JSON-RPC method name value object

=head1 SYNOPSIS

  use ValueObject::JSONRPC::MethodName;

  my $m = ValueObject::JSONRPC::MethodName->new(value => 'math.add');
  $m->value;             # 'math.add'
  "${m}";               # 'math.add'
  $m->equals('math.add'); # true

=head1 DESCRIPTION

Immutable, read-only value object representing the JSON-RPC C<method>
member. Per the JSON-RPC 2.0 specification the method MUST be a
non-empty string and names beginning with C<rpc.> are reserved and
therefore rejected.

This implementation also rejects leading/trailing whitespace,
control characters, leading/trailing dots, and empty segments (two
consecutive dots). It rejects references / objects even if they overload
stringification; only plain scalar strings are accepted.

=head1 METHODS

=head2 new

Constructor. Requires C<value> which must be a non-empty string and not
begin with C<rpc.>. Otherwise the constructor dies with a message
containing the phrase "JSON-RPC method name".

=head2 value

Accessor that returns the method name string.

=head2 equals($other)

Compare with a plain string or another C<ValueObject::JSONRPC::MethodName>
instance. Returns 1 for equal, 0 otherwise. C<undef> returns 0.

=head1 AUTHOR

nqounet

=cut
