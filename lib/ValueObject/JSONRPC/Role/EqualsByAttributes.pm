package ValueObject::JSONRPC::Role::EqualsByAttributes;
use strict;
use warnings;

use Moo::Role;
use namespace::clean;

requires '_equals_attributes';

sub equals {
    my ($self, $other) = @_;
    return 0 unless defined $other;
    return 0 unless ref $other && ref $other eq ref $self;

    for my $attr ($self->_equals_attributes) {
        my $a = $self->$attr;
        my $b = $other->$attr;

        # both undef: equal for this attribute
        next if !defined $a && !defined $b;

        # only one defined: not equal
        return 0 if defined $a xor defined $b;

        if (ref $a && $a->can('equals')) {
            return 0 unless $a->equals($b);
        }
        else {
            return 0 unless "$a" eq "$b";
        }
    }

    return 1;
}

1;
