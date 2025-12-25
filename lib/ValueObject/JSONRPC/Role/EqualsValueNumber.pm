package ValueObject::JSONRPC::Role::EqualsValueNumber;
use strict;
use warnings;

use Moo::Role;
use namespace::clean;

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
