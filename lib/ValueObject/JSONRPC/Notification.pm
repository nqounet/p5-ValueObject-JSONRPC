package ValueObject::JSONRPC::Notification;
use strict;
use warnings;
use parent 'ValueObject::JSONRPC';

use Moo;
use namespace::clean;

use ValueObject::JSONRPC::Version;
use ValueObject::JSONRPC::MethodName;
use ValueObject::JSONRPC::Params;

# Prevent passing an `id` (notifications must not have an id member)
sub BUILDARGS {
  my ($class, %args) = @_;
  if (exists $args{id}) {
    die qq{JSON-RPC notification MUST NOT include an 'id' member};
  }
  return ref $_[1] ? $_[1] : \%args;
}

has 'jsonrpc' => (
  is      => 'ro',
  default => sub { ValueObject::JSONRPC::Version->new },
  isa     => sub {
    my $v = $_[0];
    die qq{JSON-RPC notification jsonrpc must be a ValueObject::JSONRPC::Version}
      unless ref $v && ref $v eq 'ValueObject::JSONRPC::Version';
  },
);

has 'method' => (
  is       => 'ro',
  required => 1,
  isa      => sub {
    my $m = $_[0];
    die qq{JSON-RPC notification method must be a ValueObject::JSONRPC::MethodName}
      unless ref $m && ref $m eq 'ValueObject::JSONRPC::MethodName';
  },
);

has 'params' => (
  is  => 'ro',
  isa => sub {
    my $p = $_[0];
    return unless defined $p;
    die qq{JSON-RPC notification params must be a ValueObject::JSONRPC::Params}
      unless ref $p && ref $p eq 'ValueObject::JSONRPC::Params';
  },
);

sub _equals_attributes { qw(jsonrpc method params); }

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
