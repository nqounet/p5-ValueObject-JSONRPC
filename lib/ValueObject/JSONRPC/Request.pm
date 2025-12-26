package ValueObject::JSONRPC::Request;
use strict;
use warnings;
use parent 'ValueObject::JSONRPC';

use Moo;
use namespace::clean;

use ValueObject::JSONRPC::Version;
use ValueObject::JSONRPC::MethodName;
use ValueObject::JSONRPC::Params;
use ValueObject::JSONRPC::Id;

has 'jsonrpc' => (
  is      => 'ro',
  default => sub { ValueObject::JSONRPC::Version->new },
  isa     => sub {
    my $v = $_[0];
    die qq{JSON-RPC request jsonrpc must be a ValueObject::JSONRPC::Version}
      unless ref $v && ref $v eq 'ValueObject::JSONRPC::Version';
  },
);

has 'method' => (
  is       => 'ro',
  required => 1,
  isa      => sub {
    my $m = $_[0];
    die qq{JSON-RPC request method must be a ValueObject::JSONRPC::MethodName}
      unless ref $m && ref $m eq 'ValueObject::JSONRPC::MethodName';
  },
);

has 'params' => (
  is  => 'ro',
  isa => sub {
    my $p = $_[0];
    return unless defined $p;
    die qq{JSON-RPC request params must be a ValueObject::JSONRPC::Params}
      unless ref $p && ref $p eq 'ValueObject::JSONRPC::Params';
  },
);

has 'id' => (
  is       => 'ro',
  required => 1,
  isa      => sub {
    my $i = $_[0];
    die qq{JSON-RPC request id must be a ValueObject::JSONRPC::Id} unless ref $i && ref $i eq 'ValueObject::JSONRPC::Id';

    # id value MUST NOT be undef for a request (notifications omit id)
    die qq{JSON-RPC request id MUST NOT be null for a request} unless defined $i->value;
  },
);

sub _equals_attributes { qw(jsonrpc method params id); }

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
