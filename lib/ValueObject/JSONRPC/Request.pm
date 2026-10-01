package ValueObject::JSONRPC::Request;
use strict;
use warnings;
use parent 'ValueObject::JSONRPC';

use Moo;
use Types::Standard qw(InstanceOf);

use ValueObject::JSONRPC::Version;
use ValueObject::JSONRPC::MethodName;
use ValueObject::JSONRPC::Params;
use ValueObject::JSONRPC::Id;
use namespace::clean;

has 'jsonrpc' => (
  is       => 'ro',
  isa      => InstanceOf ['ValueObject::JSONRPC::Version'],
  required => 1,
);

has 'method' => (
  is       => 'ro',
  isa      => InstanceOf ['ValueObject::JSONRPC::MethodName'],
  required => 1,
);

has 'params' => (
  is  => 'ro',
  isa => InstanceOf ['ValueObject::JSONRPC::Params'],
);

has 'id' => (
  is       => 'ro',
  isa      => sub {
    InstanceOf(['ValueObject::JSONRPC::Id'])->assert_valid($_[0]);

    # id MUST NOT be null for a request (notifications omit id)
    die qq{JSON-RPC request id MUST NOT be null for a request}
      unless defined $_[0]->value;
  },
  required => 1,
);

1;
__END__

=encoding utf-8

=head1 NAME

ValueObject::JSONRPC::Request - JSON-RPC request value object

=head1 SYNOPSIS

  use ValueObject::JSONRPC::Request;
  my $req = ValueObject::JSONRPC::Request->new(
    method => ValueObject::JSONRPC::MethodName->new(value => 'sum'),
    id => ValueObject::JSONRPC::Id->new(value => 1),
  );

=head1 DESCRIPTION

Represents a JSON-RPC request with required members `jsonrpc`,
`method` and `id`. Notifications should use
L<ValueObject::JSONRPC::Notification>.

=head1 METHODS

=head2 new(%args)

Constructor; C<method> and C<id> are required for a request.

=head1 AUTHOR

nqounet

=cut
