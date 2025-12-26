package ValueObject::JSONRPC::Version;
use strict;
use warnings;
use parent 'ValueObject::JSONRPC';

use constant REQUIRED_VERSION => '2.0';

use Moo;
use Types::Standard qw(Enum);
use namespace::clean;

has 'value' => (
  is      => 'ro',
  default => sub {REQUIRED_VERSION},
  isa     => Enum ['2.0'],
);

1;
__END__

=encoding utf-8

=head1 NAME

ValueObject::JSONRPC::Version — JSON-RPC protocol version value object

=head1 SYNOPSIS

  use ValueObject::JSONRPC::Version;

  # defaults to the required version
  my $v = ValueObject::JSONRPC::Version->new;
  $v->value;            # '2.0'
  "$v";                # 'ValueObject::JSONRPC::Version(2.0)' (stringification)
  $v->equals('2.0');    # true

=head1 DESCRIPTION

Immutable, read-only value object that represents the JSON-RPC protocol
version. It enforces the required version (REQUIRED_VERSION, currently
'2.0') and will die if constructed with any other value.

=head1 METHODS

=head2 new

Constructor. Optional C<value> argument which must equal the required
version; otherwise the constructor dies with the message shown below.

  JSON-RPC version MUST be '2.0', got '...'

=head2 value

Returns the version string.

=head2 equals($other)

Compare this object with either a plain string or another
C<ValueObject::JSONRPC::Version> instance. Returns 1 for equal, 0 for not.
C<undef> returns 0. When given an object it must be the same class.

=head1 AUTHOR

nqounet

=cut
