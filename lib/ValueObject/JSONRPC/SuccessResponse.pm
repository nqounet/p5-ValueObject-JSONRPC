package ValueObject::JSONRPC::SuccessResponse;
use strict;
use warnings;
use parent 'ValueObject::JSONRPC';

use Moo;
use namespace::clean;

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
    die qq{JSON-RPC response jsonrpc must be a ValueObject::JSONRPC::Version}
      unless ref $v && ref $v eq 'ValueObject::JSONRPC::Version';
  },
);

has 'result' => (
  is       => 'ro',
  required => 1,
  isa      => sub {
    my $r = $_[0];
    die qq{JSON-RPC success response result must be a ValueObject::JSONRPC::Result}
      unless ref $r && ref $r eq 'ValueObject::JSONRPC::Result';
  },
);

has 'id' => (
  is       => 'ro',
  required => 1,
  isa      => sub {
    my $i = $_[0];
    die qq{JSON-RPC response id must be a ValueObject::JSONRPC::Id} unless ref $i && ref $i eq 'ValueObject::JSONRPC::Id';

    # allow undef id value (null) in responses
  },
);

sub _equals_attributes { qw(jsonrpc result id); }

1;
__END__

=encoding utf-8

=head1 NAME

ValueObject::JSONRPC::SuccessResponse - successful JSON-RPC response

=head1 SYNOPSIS

    use ValueObject::JSONRPC::SuccessResponse;
    my $r = ValueObject::JSONRPC::SuccessResponse->new(
        result => ValueObject::JSONRPC::Result->new(value => { ok => 1 }),
        id => ValueObject::JSONRPC::Id->new(value => 1),
    );

=head1 DESCRIPTION

Represents a successful JSON-RPC response. It contains `jsonrpc`, a
`result` (L<ValueObject::JSONRPC::Result>) and an `id`.

=head1 METHODS

=head2 new(%args)

Constructor; requires C<result> and C<id>. An `error` member is not
allowed.

=head1 AUTHOR

nqounet

=cut
