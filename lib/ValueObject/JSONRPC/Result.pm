package ValueObject::JSONRPC::Result;
use strict;
use warnings;

use Moo;
use namespace::clean -except => 'meta';
use Storable qw(freeze);

has 'value' => (
    is      => 'ro',
    default => sub {undef},
    isa     => sub {
        my $v = $_[0];
        return if !defined $v;    # null is allowed
        if (ref $v) {
            my $r = ref $v;
            unless ($r eq 'ARRAY' || $r eq 'HASH') {
                die
                  qq{JSON-RPC result must be a JSON value (scalar, array, object or null), got ref '$r'};
            }
        }

        # non-ref scalars are allowed
    },
);

sub equals {
    my ($self, $other) = @_;
    return 0 unless defined $other;

    if (ref $other) {

        # compare with same class
        if (ref $other eq ref $self) {
            my $a = $self->value;
            my $b = $other->value;
            return 1 if !defined $a    && !defined $b;
            return 0 unless defined $a && defined $b;
            if (ref $a || ref $b) {
                return freeze($a) eq freeze($b) ? 1 : 0;
            }
            return $a eq $b ? 1 : 0;
        }

        # allow comparing to raw array/hashref
        if (ref $other eq 'ARRAY' || ref $other eq 'HASH') {
            my $v = $self->value;
            return 0 unless ref $v;
            return freeze($v) eq freeze($other) ? 1 : 0;
        }

        return 0;
    }

    # other is scalar
    return 0 unless defined $self->value && !ref $self->value;
    return $self->value eq $other ? 1 : 0;
}

1;

__END__

=encoding utf-8

=head1 NAME

ValueObject::JSONRPC::Result — JSON-RPC result value object

=cut
