package ValueObject::JSONRPC::ErrorResponse;
use strict;
use warnings;

use Moo;
use namespace::clean -except => 'meta';

with 'ValueObject::JSONRPC::Role::EqualsByAttributes';

use ValueObject::JSONRPC::Version;
use ValueObject::JSONRPC::Error;
use ValueObject::JSONRPC::Id;

# Prevent passing a `result` member to an error response
sub BUILDARGS {
    my ($class, %args) = @_;
    if (exists $args{result}) {
        die qq{JSON-RPC error response MUST NOT include a 'result' member};
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

has 'error' => (
    is       => 'ro',
    required => 1,
    isa      => sub {
        my $e = $_[0];
        die
          qq{JSON-RPC error response error must be a ValueObject::JSONRPC::Error}
          unless ref $e && ref $e eq 'ValueObject::JSONRPC::Error';
    },
);

has 'id' => (
    is       => 'ro',
    required => 1,
    isa      => sub {
        my $i = $_[0];
        die qq{JSON-RPC response id must be a ValueObject::JSONRPC::Id}
          unless ref $i && ref $i eq 'ValueObject::JSONRPC::Id';
    },
);

sub _equals_attributes { qw(jsonrpc error id); }

1;
__END__

=head1 NAME

ValueObject::JSONRPC::ErrorResponse - failed JSON-RPC response

=cut
