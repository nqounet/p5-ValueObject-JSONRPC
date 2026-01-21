package ValueObject::JSONRPC::Id;
use strict;
use warnings;
use parent 'ValueObject::JSONRPC';

use Moo;
use Types::Standard qw(Maybe Str Num);
use namespace::clean;

has 'value' => (
  is      => 'ro',
  default => sub {undef},
  isa     => Maybe [Str | Num],
);

1;

__END__

=encoding utf-8

=head1 NAME

ValueObject::JSONRPC::Id — JSON-RPC id value object

=head1 SYNOPSIS

    use ValueObject::JSONRPC::Id;
    my $id = ValueObject::JSONRPC::Id->new(value => 123);

=head1 DESCRIPTION

Value object for the JSON-RPC C<id> member. The id may be a string,
number or null (C<undef>). It must not be a reference.

=head1 METHODS

=head2 new(value => $val)

Constructor; C<value> may be undef for a null id.

=head2 value

Returns the id value.

=head2 equals($other)

Compare with another id object or a plain scalar. Returns 1 for equal.

=head1 AUTHOR

nqounet

=cut
