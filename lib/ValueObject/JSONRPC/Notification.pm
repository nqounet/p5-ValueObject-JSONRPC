package ValueObject::JSONRPC::Notification;
use strict;
use warnings;
use parent 'ValueObject::JSONRPC';

use Moo;
use Types::Standard qw(InstanceOf);

use ValueObject::JSONRPC::Version;
use ValueObject::JSONRPC::MethodName;
use ValueObject::JSONRPC::Params;
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

sub to_json {
  my ($self) = @_;

  my %out = (
    jsonrpc => $self->jsonrpc->value,
    method  => $self->method->value,
  );

  if (defined $self->params) {
    $out{params} = $self->params->value;
  }

  return \%out;
}

1;
__END__
=head1 NAME

=encoding utf-8

=head1 NAME
=head1 NAME

ValueObject::JSONRPC::Notification - JSON-RPC notification value object

=head1 SYNOPSIS

    use ValueObject::JSONRPC::Notification;
    my $n = ValueObject::JSONRPC::Notification->new(
        method => ValueObject::JSONRPC::MethodName->new(value => 'foo'),
        params => ValueObject::JSONRPC::Params->new(value => []),
    );

=head1 DESCRIPTION

Represents a JSON-RPC notification (a request without an `id`). The
object contains `jsonrpc`, `method` and optional `params` members.

=head1 METHODS

=head2 new(%args)

Constructor; C<method> is required, C<params> is optional.

=head1 AUTHOR

nqounet

=cut
