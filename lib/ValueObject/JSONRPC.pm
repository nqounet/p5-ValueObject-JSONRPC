package ValueObject::JSONRPC;
use strict;
use warnings;
use version;

our $VERSION = version->declare("v2.0.0");

use Data::Dumper qw(DumperX);

sub to_string {
  local $Data::Dumper::Indent    = 0;
  local $Data::Dumper::Terse     = 1;
  local $Data::Dumper::Quotekeys = 0;
  local $Data::Dumper::Sortkeys  = 1;
  DumperX($_[0]);
}

sub equals {
  my ($self, $other) = @_;
  ref $self eq ref $other && $self->to_string eq $other->to_string;
}

1;
__END__

=encoding utf-8

=head1 NAME

ValueObject::JSONRPC - JSON-RPC value objects

=head1 SYNOPSIS

    use ValueObject::JSONRPC;

=head1 DESCRIPTION

Top-level distribution that provides JSON-RPC value objects. Currently
the distribution implements the JSON-RPC `jsonrpc` version value object
as `ValueObject::JSONRPC::Version`.

The distribution implements a small, focused set of immutable value
objects that model the JSON-RPC 2.0 protocol primitives. Each value
object validates its input in the constructor and provides an `equals`
method for comparisons.

Implemented value objects:

- `ValueObject::JSONRPC::Version`
- `ValueObject::JSONRPC::MethodName`
- `ValueObject::JSONRPC::Id`
- `ValueObject::JSONRPC::Params`
- `ValueObject::JSONRPC::Code`
- `ValueObject::JSONRPC::Error`
- `ValueObject::JSONRPC::Result`
- `ValueObject::JSONRPC::Request`, `Notification`, `SuccessResponse`, `ErrorResponse`

SEE ALSO

L<ValueObject::JSONRPC::Version>, L<ValueObject::JSONRPC::MethodName>,
L<ValueObject::JSONRPC::Id>, L<ValueObject::JSONRPC::Params>,
L<ValueObject::JSONRPC::Code>, L<ValueObject::JSONRPC::Error>,
L<ValueObject::JSONRPC::Result>

INSTALLATION

Install prerequisites and run tests locally:

    cpanm -nq --installdeps --with-develop --with-recommends .
    minil test
    # or
    prove -lr t

=head1 LICENSE

=head1 VERSION

This document corresponds to distribution version $VERSION.


Copyright (C) nqounet.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

nqounet

=cut
