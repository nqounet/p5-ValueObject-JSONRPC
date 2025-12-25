package ValueObject::JSONRPC::MethodName;
use strict;
use warnings;

use Moo;
use namespace::clean -except => 'meta';

with 'ValueObject::JSONRPC::Role::EqualsValueString';

use overload
  '""'     => sub { $_[0]->value },
  fallback => 1;

has 'value' => (
    is       => 'ro',
    required => 1,
    isa      => sub {
        my $v       = $_[0];
        my $display = defined $v ? (ref $v ? ref $v : $v) : '<undef>';

        # must be defined, non-ref, non-empty string
        unless (defined $v && !ref $v && length($v)) {
            die
              qq{JSON-RPC method name MUST be a non-empty string, got '$display'};
        }

      # reject purely-numeric literal values (e.g. 1) — method must be a string
        if ($v =~ /^[+-]?\d+(?:\.\d+)?$/) {
            die qq{JSON-RPC method name MUST be a non-empty string, got '$v'};
        }

        # names beginning with 'rpc.' are reserved by the spec
        if ($v =~ /^rpc\./) {
            die qq{JSON-RPC method name MUST NOT begin with 'rpc.', got '$v'};
        }
    },
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
