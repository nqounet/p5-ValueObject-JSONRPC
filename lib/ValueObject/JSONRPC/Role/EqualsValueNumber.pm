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

__END__
=head1 NAME

=encoding utf-8

=head1 NAME
=head1 NAME

ValueObject::JSONRPC::Role::EqualsValueNumber - numeric value equality role

=head1 DESCRIPTION

Role that provides an C<equals> method for objects whose identity is a
numeric C<value> attribute. Can compare against raw numbers or same-class
objects.

=head1 AUTHOR

nqounet

=cut
