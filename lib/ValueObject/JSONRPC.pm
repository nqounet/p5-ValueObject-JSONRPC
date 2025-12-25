package ValueObject::JSONRPC;
use strict;
use warnings;
use version;

our $VERSION = version->declare("v2.0.0");

# See ValueObject::JSONRPC::Version for the JSON-RPC protocol version value object

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

=head1 LICENSE

Copyright (C) nqounet.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

nqounet

=cut
