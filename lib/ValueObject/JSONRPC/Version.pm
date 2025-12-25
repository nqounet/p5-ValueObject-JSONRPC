package ValueObject::JSONRPC::Version;
use strict;
use warnings FATAL => 'all';

use Moo;
use namespace::clean -except => 'meta';
use overload '""' => sub { $_[0]->value }, fallback => 1;

has 'value' => (
  is      => 'ro',
  default => sub {'2.0'},
  isa     => sub {
    die qq{JSON-RPC version MUST be '2.0', got '$_[0]'}
      unless defined $_[0] && $_[0] eq '2.0';
  },
);

sub equals {
  my ($self, $other) = @_;

  return unless defined $other;

  if (ref $other) {
    return unless ref $other eq ref $self;
    return $self->value eq $other->value;
  }

  return $self->value eq $other;
}

1;
__END__

=encoding utf-8

=head1 NAME

ValueObject::JSONRPC::Version - JSON-RPC protocol version value object

=head1 SYNOPSIS

  use ValueObject::JSONRPC::Version;

  # defaults to the required JSON-RPC version string '2.0'
  my $v  = ValueObject::JSONRPC::Version->new;
  my $v2 = ValueObject::JSONRPC::Version->new( value => '2.0' );

  say $v->value;        # '2.0'
  say "$v";             # '2.0' (stringification)
  $v->equals('2.0');    # true
  $v->equals($v2);      # true

=head1 DESCRIPTION

Immutable (read-only) value object that represents the JSON-RPC protocol
version. JSON-RPC 2.0 requires the exact string '2.0' for the "jsonrpc"
member; this object enforces that requirement.

=head1 METHODS

=head2 new

  my $v = ValueObject::JSONRPC::Version->new;
  my $v = ValueObject::JSONRPC::Version->new( value => '2.0' );

Constructor. Accepts an optional C<value> argument. The value must be the
string C<'2.0'>; providing any other value (including numeric 2, other
strings like C<'2'> or C<'1.0'>, or non‑scalar references) will cause the
constructor to die with the message:

  JSON-RPC version MUST be '2.0', got '...'

=head2 value

  my $str = $v->value;

Read-only accessor that returns the version string (always C<'2.0'> for a
successfully constructed object).

=head2 equals($other)

  $v->equals('2.0');   # true
  $v->equals($other_v); # true if $other_v is the same class and has value '2.0'
  $v->equals(undef);   # false

Compare this object with either a plain string or another
C<ValueObject::JSONRPC::Version> instance. Behavior:

- If C<$other> is undef returns false.
- If C<$other> is an object, it must be the same class; otherwise returns false.
- If C<$other> is a string, returns true when the string equals this object's value.

=head1 AUTHOR

nqounet

=cut
