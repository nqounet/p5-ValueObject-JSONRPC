package ValueObject::JSONRPC::Error;
use strict;
use warnings;

use Moo;
use namespace::clean -except => 'meta';

has 'code' => (
    is       => 'ro',
    required => 1,
    isa      => sub {
        my $c = $_[0];

        # must be a ValueObject::JSONRPC::Code instance
        die qq{JSON-RPC error code must be a ValueObject::JSONRPC::Code}
          unless ref $c && ref $c eq 'ValueObject::JSONRPC::Code';
    },
);

has 'message' => (
    is       => 'ro',
    required => 1,
    isa      => sub {
        my $m = $_[0];
        unless (defined $m && !ref $m && length $m) {
            die qq{JSON-RPC error message must be a non-empty string};
        }
    },
);

has 'data' => (
    is => 'ro',
);

sub equals {
    my ($self, $other) = @_;
    return 0 unless defined $other;

    if (ref $other) {
        return 0 unless ref $other eq ref $self;
        return 0 unless $self->code->equals($other->code);
        return 0 unless $self->message eq $other->message;

        # compare data by stringified Storable freeze when both refs
        if (ref $self->data || ref $other->data) {
            use Storable qw(freeze);
            return ( defined $self->data
                  && defined $other->data
                  && freeze($self->data) eq freeze($other->data)) ? 1 : 0;
        }
        return ($self->data // '') eq ($other->data // '') ? 1 : 0;
    }

    return 0;
}

1;

__END__

=encoding utf-8

=head1 NAME

ValueObject::JSONRPC::Error — JSON-RPC error value object

=head1 SYNOPSIS

    use ValueObject::JSONRPC::Error;
    my $err = ValueObject::JSONRPC::Error->new(
        code => ValueObject::JSONRPC::Code->new(value => -32600),
        message => 'Invalid Request',
        data => { detail => '...' }
    );

=head1 DESCRIPTION

Value object representing the JSON-RPC C<error> structure. It holds
a `code` (L<ValueObject::JSONRPC::Code>), a textual `message` and
optional `data` that may be any JSON value.

=head1 METHODS

=head2 new(%args)

Constructor; requires C<code> and C<message>, optional C<data>.

=head2 code, message, data

Accessors for the corresponding members.

=head2 equals($other)

Compare with another error object. Returns 1 for equal, 0 otherwise.

=head1 AUTHOR

nqounet

=cut
