package ValueObject::JSONRPC::Codec;
use strict;
use warnings;

use Moo;
use Scalar::Util qw(blessed);
use JSON::PP ();
use namespace::clean;

use ValueObject::JSONRPC::X;
use ValueObject::JSONRPC::Version;
use ValueObject::JSONRPC::MethodName;
use ValueObject::JSONRPC::Params;
use ValueObject::JSONRPC::Id;
use ValueObject::JSONRPC::Code;
use ValueObject::JSONRPC::Error;
use ValueObject::JSONRPC::Result;
use ValueObject::JSONRPC::Request;
use ValueObject::JSONRPC::Notification;
use ValueObject::JSONRPC::SuccessResponse;
use ValueObject::JSONRPC::ErrorResponse;

# JSON 実装はここだけで差し替える（encode / decode を持つオブジェクト）
has 'json' => (
  is      => 'ro',
  default => sub { JSON::PP->new->utf8->canonical },
);

my $PKG = 'ValueObject::JSONRPC';

sub _invalid { "${PKG}::X::InvalidRequest"->throw(message => $_[0]) }

sub decode {
  my ($self, $text) = @_;
  "${PKG}::X::ParseError"->throw(message => 'JSON text must be a string')
    if !defined $text || ref $text;

  my $data = eval { $self->json->decode($text) };
  if (my $err = $@) {
    chomp $err;
    "${PKG}::X::ParseError"->throw(message => $err);
  }

  return $self->_decode_message($data) unless ref $data eq 'ARRAY';

  _invalid('batch MUST NOT be empty') unless @$data;
  return [
    map {
      my $m = eval { $self->_decode_message($_) };
      if (my $err = $@) {
        die $err unless blessed $err && $err->isa("${PKG}::X");
        $err;
      }
      else {$m}
    } @$data
  ];
}

sub _decode_message {
  my ($self, $h) = @_;
  _invalid('message MUST be an object') unless ref $h eq 'HASH';
  _invalid(q{'jsonrpc' is required}) unless exists $h->{jsonrpc};
  my $version = "${PKG}::Version"->new(value => $h->{jsonrpc});

  if (exists $h->{method}) {
    my %args = (
      jsonrpc => $version,
      method  => "${PKG}::MethodName"->new(value => $h->{method}),
    );
    $args{params} = "${PKG}::Params"->new(value => $h->{params}) if exists $h->{params};
    return "${PKG}::Notification"->new(%args) unless exists $h->{id};
    return "${PKG}::Request"->new(%args, id => "${PKG}::Id"->new(value => $h->{id}));
  }

  _invalid(q{response MUST have 'result' or 'error'})
    unless exists $h->{result} || exists $h->{error};
  _invalid(q{response MUST NOT have both 'result' and 'error'})
    if exists $h->{result} && exists $h->{error};
  _invalid(q{'id' is required}) unless exists $h->{id};

  my %args = (jsonrpc => $version, id => "${PKG}::Id"->new(value => $h->{id}));
  return "${PKG}::SuccessResponse"->new(%args, result => "${PKG}::Result"->new(value => $h->{result}))
    if exists $h->{result};

  my $e = $h->{error};
  _invalid(q{'error' MUST be an object}) unless ref $e eq 'HASH';
  _invalid(q{error 'code' and 'message' are required}) unless exists $e->{code} && exists $e->{message};
  return "${PKG}::ErrorResponse"->new(
    %args,
    error => "${PKG}::Error"->new(
      code    => "${PKG}::Code"->new(value => $e->{code}),
      message => $e->{message},
      (exists $e->{data} ? (data => $e->{data}) : ()),
    ),
  );
}

# メッセージ、またはメッセージの配列（batch）を JSON 文字列にする
sub encode {
  my ($self, $msg) = @_;
  return $self->json->encode($self->_to_data($msg));
}

sub _to_data {
  my ($self, $m) = @_;
  return [map { $self->_to_data($_) } @$m] if ref $m eq 'ARRAY';

  my %out = (jsonrpc => $m->jsonrpc->value);
  if ($m->isa("${PKG}::Request") || $m->isa("${PKG}::Notification")) {
    $out{method} = $m->method->value;
    $out{params} = $m->params->value if defined $m->params;
    $out{id}     = $m->id->value     if $m->isa("${PKG}::Request");
  }
  else {
    $out{id} = $m->id->value;
    if ($m->isa("${PKG}::SuccessResponse")) {
      $out{result} = $m->result->value;
    }
    else {
      my $e = $m->error;
      $out{error} = {code => $e->code->value, message => $e->message};
      $out{error}{data} = $e->data if defined $e->data;    # ponytail: data=null は省略扱い
    }
  }
  return \%out;
}

1;
__END__

=encoding utf-8

=head1 NAME

ValueObject::JSONRPC::Codec - JSON text and JSON-RPC message conversion

=head1 SYNOPSIS

  my $codec = ValueObject::JSONRPC::Codec->new;

  my $msg = eval { $codec->decode($text) };
  if (my $x = $@) { my $error = $x->to_error }   # ParseError / InvalidRequest / InvalidParams

  my $text = $codec->encode($msg);

=head1 DESCRIPTION

Converts between a JSON string and the value objects. The value objects
themselves know nothing about JSON. The JSON implementation defaults to
L<JSON::PP> and can be replaced with the C<json> constructor argument
(any object with C<encode> and C<decode>).

C<decode> takes a UTF-8 encoded byte string and C<encode> returns one
(the wire format). Decode character strings with C<Encode::encode_utf8>
first. JSON C<true> / C<false> are kept as C<JSON::PP::Boolean> objects.

=head1 METHODS

=head2 decode($text)

Returns a Request, Notification, SuccessResponse or ErrorResponse. Dies with
L<ValueObject::JSONRPC::X::ParseError> when C<$text> is not JSON, and with
C<X::InvalidRequest> / C<X::InvalidParams> when the message violates the
specification.

For a batch (JSON array) it returns an array reference with one entry per
element, in order: the message, or the X exception for an invalid element.
An empty batch dies with C<X::InvalidRequest>.

=head2 encode($message_or_arrayref)

Returns a JSON string. An array reference becomes a batch. An undefined
C<Error> data is omitted.

=cut
