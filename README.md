[![Actions Status](https://github.com/nqounet/p5-ValueObject-JSONRPC/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/nqounet/p5-ValueObject-JSONRPC/actions?workflow=test)

# ValueObject::JSONRPC

Lightweight set of immutable value objects implementing the JSON-RPC
2.0 primitives used for validating and composing JSON-RPC messages.

Implemented value objects

- `ValueObject::JSONRPC::Version` — the `jsonrpc` member (must be the exact string "2.0")
- `ValueObject::JSONRPC::MethodName` — the `method` member (non-empty string, not starting with `rpc.`)
- `ValueObject::JSONRPC::Id` — the `id` member (string, number, or null)
- `ValueObject::JSONRPC::Params` — the `params` member (JSON array or object)
- `ValueObject::JSONRPC::Code` — the error `code` (integer)
- `ValueObject::JSONRPC::Error` — error object with `code`, `message`, optional `data`
- `ValueObject::JSONRPC::Result` — the `result` member (any JSON value)
- `ValueObject::JSONRPC::Request`, `Notification`, `SuccessResponse`, `ErrorResponse` — message envelopes

Installation

Install prerequisites and the module from the distribution root:

```bash
cpanm -nq --installdeps --with-develop --with-recommends .
```

Run the test suite

```bash
prove -lr t
```

Developer notes

- Value objects use `Moo` + `namespace::clean` and are strict about types: constructors die on invalid input.
- Equality helpers `->equals($other)` accept either a plain scalar or another object of the same class.
- Deep comparisons for complex structures use `Storable::freeze` internally where appropriate.
- When adding new value objects, add a corresponding test under `t/value_object/jsonrpc/`.

License

This software is distributed under the same terms as Perl itself.

Author

nqounet <mail@nqou.net>
