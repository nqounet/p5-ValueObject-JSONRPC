package ValueObject::JSONRPC::Params;
use strict;
use warnings;

use Moo;
use namespace::clean -except => 'meta';
use Storable qw(freeze);

has 'value' => (
    is       => 'ro',
    required => 1,
    isa      => sub {
        my $v = $_[0];
        unless (ref $v && (ref $v eq 'ARRAY' || ref $v eq 'HASH')) {
            die qq{JSON-RPC params MUST be an Array or Object, got }
              . (defined $v ? ref $v : '<undef>');
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

=cut
