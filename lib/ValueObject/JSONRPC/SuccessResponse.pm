package ValueObject::JSONRPC::SuccessResponse;
use strict;
use warnings;

use Moo;
use namespace::clean -except => 'meta';

use ValueObject::JSONRPC::Version;
use ValueObject::JSONRPC::Result;
use ValueObject::JSONRPC::Id;

# Prevent passing an `error` member to a success response
sub BUILDARGS {
    my ($class, %args) = @_;
    if (exists $args{error}) {
        die qq{JSON-RPC success response MUST NOT include an 'error' member};
    }
    return ref $_[1] ? $_[1] : \%args;
}

has 'jsonrpc' => (
    is      => 'ro',
    default => sub { ValueObject::JSONRPC::Version->new },
    isa     => sub {
        my $v = $_[0];
        die
          qq{JSON-RPC response jsonrpc must be a ValueObject::JSONRPC::Version}
          unless ref $v && ref $v eq 'ValueObject::JSONRPC::Version';
    },
);

has 'result' => (
    is       => 'ro',
    required => 1,
    isa      => sub {
        my $r = $_[0];
        die
          qq{JSON-RPC success response result must be a ValueObject::JSONRPC::Result}
          unless ref $r && ref $r eq 'ValueObject::JSONRPC::Result';
    },
);

has 'id' => (
    is       => 'ro',
    required => 1,
    isa      => sub {
        my $i = $_[0];
        die qq{JSON-RPC response id must be a ValueObject::JSONRPC::Id}
          unless ref $i && ref $i eq 'ValueObject::JSONRPC::Id';

        # allow undef id value (null) in responses
    },
);

sub equals {
    my ($self, $other) = @_;
    return 0 unless defined $other;
    return 0 unless ref $other && ref $other eq ref $self;
    return 0 unless $self->jsonrpc->equals($other->jsonrpc);
    return 0 unless $self->result->equals($other->result);
    return $self->id->equals($other->id) ? 1 : 0;
}

1;
__END__

=head1 NAME

ValueObject::JSONRPC::SuccessResponse - successful JSON-RPC response

=cut
