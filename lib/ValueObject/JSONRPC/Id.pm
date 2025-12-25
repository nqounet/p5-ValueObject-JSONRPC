package ValueObject::JSONRPC::Id;
use strict;
use warnings;

use Moo;
use namespace::clean -except => 'meta';

use overload
  '""'     => sub { defined $_[0]->value ? $_[0]->value : '' },
  fallback => 1;

has 'value' => (
    is      => 'ro',
    default => sub {undef},
    isa     => sub {
        my $v = $_[0];

        # allow undef (null id)
        return if !defined $v;

        # must be a non-ref scalar (string or number)
        if (ref $v) {
            die qq{JSON-RPC id MUST be a String, Number, or null, got ref};
        }
    },
);

sub equals {
    my ($self, $other) = @_;
    return 0 unless defined $other;

    if (ref $other) {
        return 0 unless ref $other eq ref $self;
        my $a = $self->value;
        my $b = $other->value;
        return 1 if !defined $a    && !defined $b;
        return 0 unless defined $a && defined $b;
        return $a eq $b ? 1 : 0;
    }

    return 0 unless defined $self->value;
    return $self->value eq $other ? 1 : 0;
}

1;

__END__

=encoding utf-8

=head1 NAME

ValueObject::JSONRPC::Id — JSON-RPC id value object

=cut
