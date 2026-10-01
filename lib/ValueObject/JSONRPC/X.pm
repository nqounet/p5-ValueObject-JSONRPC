package ValueObject::JSONRPC::X;
use strict;
use warnings;
use Scalar::Util qw(blessed);

use overload
  '""'     => sub { $_[0]{message} },
  'bool'   => sub {1},
  fallback => 1;

# 派生クラスが code / title を定義する
sub code  {die 'abstract'}
sub title {die 'abstract'}

sub new {
  my ($class, %args) = @_;
  bless {message => $args{message} // $class->title}, $class;
}

sub message { $_[0]{message} }

sub throw {
  my $class = shift;
  die $class->new(@_);
}

sub to_error {
  my $self = shift;
  require ValueObject::JSONRPC::Code;
  require ValueObject::JSONRPC::Error;
  ValueObject::JSONRPC::Error->new(
    code    => ValueObject::JSONRPC::Code->new(value => $self->code),
    message => $self->title,
    data    => $self->message,
  );
}

# 各値オブジェクトの new を包み、検証失敗を X に変換する（around new 用）
sub wrap_new {
  my ($orig, $class, @args) = @_;
  my $obj = eval { $class->$orig(@args) };
  return $obj if defined $obj;
  my $err = $@;
  die $err if blessed $err && $err->isa(__PACKAGE__);
  chomp(my $msg = "$err");
  my $x = $class->isa('ValueObject::JSONRPC::Params') ? 'InvalidParams' : 'InvalidRequest';
  "ValueObject::JSONRPC::X::$x"->throw(message => $msg);
}

package ValueObject::JSONRPC::X::ParseError;
our @ISA = ('ValueObject::JSONRPC::X');
sub code  {-32700}
sub title {'Parse error'}

package ValueObject::JSONRPC::X::InvalidRequest;
our @ISA = ('ValueObject::JSONRPC::X');
sub code  {-32600}
sub title {'Invalid Request'}

package ValueObject::JSONRPC::X::InvalidParams;
our @ISA = ('ValueObject::JSONRPC::X');
sub code  {-32602}
sub title {'Invalid params'}

1;
__END__

=encoding utf-8

=head1 NAME

ValueObject::JSONRPC::X - exceptions for invalid JSON-RPC values

=head1 SYNOPSIS

  my $obj = eval { ValueObject::JSONRPC::Params->new(value => 1) };
  if (my $x = $@) {
    $x->isa('ValueObject::JSONRPC::X::InvalidParams');   # true
    my $error = $x->to_error;    # ValueObject::JSONRPC::Error (-32602)
  }

=head1 DESCRIPTION

Every value object's constructor throws one of these instead of a bare
string when its input violates the specification. The object
stringifies to the original validation message.

=over

=item C<X::ParseError> (-32700)

Reserved for consumers that fail to parse JSON; no constructor throws it.

=item C<X::InvalidRequest> (-32600)

Any invalid value except C<Params>.

=item C<X::InvalidParams> (-32602)

Invalid C<Params>.

=back

=head1 METHODS

=head2 code, message

=head2 to_error

Returns a L<ValueObject::JSONRPC::Error> with the standard code and title;
the validation message is placed in C<data>.

=cut
