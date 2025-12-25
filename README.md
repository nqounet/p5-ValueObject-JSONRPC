[![Actions Status](https://github.com/nqounet/p5-ValueObject-JSONRPC/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/nqounet/p5-ValueObject-JSONRPC/actions?workflow=test)
# NAME

ValueObject::JSONRPC - JSON-RPC value objects

# SYNOPSIS

```perl
use ValueObject::JSONRPC;
```

# DESCRIPTION

Top-level distribution that provides JSON-RPC value objects. Currently
the distribution implements the JSON-RPC \`jsonrpc\` version value object
as \`ValueObject::JSONRPC::Version\`.

The distribution implements a small, focused set of immutable value
objects that model the JSON-RPC 2.0 protocol primitives. Each value
object validates its input in the constructor and provides an \`equals\`
method for comparisons.

Implemented value objects:

\- \`ValueObject::JSONRPC::Version\`
\- \`ValueObject::JSONRPC::MethodName\`
\- \`ValueObject::JSONRPC::Id\`
\- \`ValueObject::JSONRPC::Params\`
\- \`ValueObject::JSONRPC::Code\`
\- \`ValueObject::JSONRPC::Error\`
\- \`ValueObject::JSONRPC::Result\`
\- \`ValueObject::JSONRPC::Request\`, \`Notification\`, \`SuccessResponse\`, \`ErrorResponse\`

SEE ALSO

[ValueObject::JSONRPC::Version](https://metacpan.org/pod/ValueObject%3A%3AJSONRPC%3A%3AVersion), [ValueObject::JSONRPC::MethodName](https://metacpan.org/pod/ValueObject%3A%3AJSONRPC%3A%3AMethodName),
[ValueObject::JSONRPC::Id](https://metacpan.org/pod/ValueObject%3A%3AJSONRPC%3A%3AId), [ValueObject::JSONRPC::Params](https://metacpan.org/pod/ValueObject%3A%3AJSONRPC%3A%3AParams),
[ValueObject::JSONRPC::Code](https://metacpan.org/pod/ValueObject%3A%3AJSONRPC%3A%3ACode), [ValueObject::JSONRPC::Error](https://metacpan.org/pod/ValueObject%3A%3AJSONRPC%3A%3AError),
[ValueObject::JSONRPC::Result](https://metacpan.org/pod/ValueObject%3A%3AJSONRPC%3A%3AResult)

INSTALLATION

Install prerequisites and run tests locally:

```
cpanm -nq --installdeps --with-develop --with-recommends .
minil test
# or
prove -lr t
```

# LICENSE

# VERSION

This document corresponds to distribution version $VERSION.

Copyright (C) nqounet.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

nqounet
