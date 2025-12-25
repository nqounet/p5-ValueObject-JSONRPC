package ValueObject::JSONRPC::Version;
use strict;
use warnings;

use constant REQUIRED_VERSION => '2.0';

use Moo;
use namespace::clean -except => 'meta';

with 'ValueObject::JSONRPC::Role::EqualsValueString';

use overload
  '""'     => sub { $_[0]->value },
  fallback => 1;

has 'value' => (
    is      => 'ro',
    default => sub {REQUIRED_VERSION},
    isa     => sub {
        my $v       = $_[0];
        my $display = defined $v ? $v : '<undef>';
        unless (defined $v && !ref $v && $v eq REQUIRED_VERSION) {
            die qq{JSON-RPC version MUST be '}
              . REQUIRED_VERSION
              . qq{', got '$display'};
        }
    },
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
  "$v";                # '2.0' (stringification)
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
