package ValueObject::JSONRPC::Code;
use strict;
use warnings;

use Moo;
use namespace::clean -except => 'meta';

use overload '""' => sub { $_[0]->value }, fallback => 1;

has 'value' => (
  is       => 'ro',
  required => 1,
  isa      => sub {
    my $v = $_[0];
    if (ref $v) {
      die qq{JSON-RPC code MUST be an integer, got ref};
    }
    unless (defined $v && $v =~ /^-?\d+$/) {
      die qq{JSON-RPC code MUST be an integer, got '} . (defined $v ? $v : '<undef>') . qq{' };
    }
  },
);

sub equals {
  my ($self, $other) = @_;
  return 0 unless defined $other;

  if (ref $other) {
    return 0 unless ref $other eq ref $self;
    return $self->value == $other->value ? 1 : 0;
  }

  return $self->value == $other ? 1 : 0;
}

1;

__END__

=encoding utf-8

=head1 NAME

ValueObject::JSONRPC::Code — JSON-RPC error code value object

=cut
