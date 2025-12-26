package ValueObject::JSONRPC::Code;
use strict;
use warnings;
use parent 'ValueObject::JSONRPC';

use Moo;
use namespace::clean;
use Scalar::Util qw(looks_like_number);
use B ();

has 'value' => (
  is       => 'ro',
  required => 1,
  isa      => sub {
    my $v = $_[0];
    if (ref $v) {
      die qq{JSON-RPC code MUST be an integer, got ref};
    }
    unless (defined $v) {
      die qq{JSON-RPC code MUST be an integer, got '<undef>'};
    }

    # must be a numeric scalar (reject non-numeric strings)
    unless (looks_like_number($v)) {
      die qq{JSON-RPC code MUST be an integer, got '} . $v . qq{' };
    }

    # reject numeric strings: detect if the scalar currently has a POK flag
    # (i.e. it is stored/known as a string) and looks_like_number succeeded
    # — in that case we want to refuse (tests expect numeric strings to be rejected).
    my $sv = B::svref_2object(\$v);
    if ($sv->POK) {
      die qq{JSON-RPC code MUST be an integer, got '} . $v . qq{' };
    }

    # must be an integer value
    unless ($v == int($v)) {
      die qq{JSON-RPC code MUST be an integer, got '} . $v . qq{' };
    }
  },
);

1;

__END__

=encoding utf-8

=head1 NAME

ValueObject::JSONRPC::Code — JSON-RPC error code value object

=head1 SYNOPSIS

    use ValueObject::JSONRPC::Code;
    my $c = ValueObject::JSONRPC::Code->new(value => 123);

=head1 DESCRIPTION

Immutable value object representing a JSON-RPC error code. The code
must be an integer.

=head1 METHODS

=head2 new(value => $int)

Constructor; C<value> is required and must be an integer.

=head2 value

Returns the integer code.

=head2 equals($other)

Compare with another code object or a plain integer. Returns 1 for
equal, 0 otherwise.

=head1 AUTHOR

nqounet

=cut
