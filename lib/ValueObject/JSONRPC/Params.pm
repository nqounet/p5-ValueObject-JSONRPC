package ValueObject::JSONRPC::Params;
use strict;
use warnings;
use parent 'ValueObject::JSONRPC';

use Moo;
use Types::Standard qw(ArrayRef HashRef);
use namespace::clean;

has 'value' => (
  is       => 'ro',
  required => 1,
  isa      => ArrayRef | HashRef,
);

1;

__END__

=encoding utf-8

=head1 NAME

ValueObject::JSONRPC::Params — JSON-RPC params value object

=head1 SYNOPSIS

    use ValueObject::JSONRPC::Params;
    my $p = ValueObject::JSONRPC::Params->new(value => { x => 1 });

=head1 DESCRIPTION

Represents the JSON-RPC `params` member which must be an array or
object. The value is stored as an arrayref or hashref.

=head1 METHODS

=head2 new(value => $arrayref|$hashref)

Constructor; C<value> must be an arrayref or hashref.

=head2 equals($other)

Compare with another params object or a raw array/hashref. Comparison
is done by stringifying via L<Storable>'s C<freeze>.

=head1 AUTHOR

nqounet

=cut
