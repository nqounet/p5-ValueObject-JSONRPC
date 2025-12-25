package ValueObject::JSONRPC::Code;
use strict;
use warnings;

use Moo;
use namespace::clean -except => 'meta';

with 'ValueObject::JSONRPC::Role::EqualsValueNumber';

use overload
  '""'     => sub { $_[0]->value },
  fallback => 1;

has 'value' => (
    is       => 'ro',
    required => 1,
    isa      => sub {
        my $v = $_[0];
        if (ref $v) {
            die qq{JSON-RPC code MUST be an integer, got ref};
        }
        unless (defined $v && $v =~ /^-?\d+$/) {
            die qq{JSON-RPC code MUST be an integer, got '}
              . (defined $v ? $v : '<undef>') . qq{' };
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
