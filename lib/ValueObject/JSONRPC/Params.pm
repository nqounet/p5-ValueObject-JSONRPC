package ValueObject::JSONRPC::Params;
use strict;
use warnings;
use parent 'ValueObject::JSONRPC';

use Moo;
use Storable qw(freeze);
use namespace::clean;

has 'value' => (
  is       => 'ro',
  required => 1,
  isa      => sub {
    my $v = $_[0];
    unless (ref $v && (ref $v eq 'ARRAY' || ref $v eq 'HASH')) {
      die qq{JSON-RPC params MUST be an Array or Object, got } . (defined $v ? ref $v : '<undef>');
    }
  },
);

sub equals {
  my ($self, $other) = @_;
  return 0 unless defined $other;

  # compare against same class
  if (ref $other) {
    if (ref $other eq ref $self) {
      return freeze($self->value) eq freeze($other->value) ? 1 : 0;
    }

    # also allow raw arrayref/hashref comparison
    if (ref $other eq 'ARRAY' || ref $other eq 'HASH') {
      return freeze($self->value) eq freeze($other) ? 1 : 0;
    }
    return 0;
  }

  return 0;
}

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
