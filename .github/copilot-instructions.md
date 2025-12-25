# GitHub Copilot / AI agent instructions for p5-ValueObject-JSONRPC

Short, concrete guidance so an AI can be productive immediately in this repo.

(keep existing content above; add the following AI-agent focused notes)

## AI-agent additions (discovered patterns & quick checklist)

- Inspect these files first when changing behavior:
  - lib/ValueObject/JSONRPC.pm (package entry / $VERSION)
  - lib/ValueObject/JSONRPC/Version.pm
  - lib/ValueObject/JSONRPC/MethodName.pm
  - lib/ValueObject/JSONRPC/Id.pm
  - lib/ValueObject/JSONRPC/Params.pm
  - lib/ValueObject/JSONRPC/Code.pm
  - lib/ValueObject/JSONRPC/Error.pm
  - lib/ValueObject/JSONRPC/Result.pm
  - Tests: t/value_object/jsonrpc/*.t

- Dev workflow (match CI exactly):
  - Install deps: `cpanm -nq --installdeps --with-develop --with-recommends .`
  - Run tests: `prove -lr t`
  - CI uses the same commands; use them locally to reproduce CI.

- Concrete conventions to follow:
  - Use `Moo` + `namespace::clean` for objects.
  - Constructors must `die` on invalid input; tests assert die-messages with regexes.
  - Provide `equals($other)` that accepts a scalar OR same-class instance; return `1`/`0`.
  - Implement stringification with `overload '""' => sub { $_[0]->value }` when appropriate.
  - Use `Storable::freeze` for deep equality comparisons (used in `Params`, `Result`, `Error->data`).

- VO-specific rules (explicit):
  - `Version`: only the exact string `'2.0'`.
  - `MethodName`: non-empty string; MUST NOT start with `rpc.`; reject pure-numeric scalars.
  - `Id`: allowed types: `undef` (null), non-ref scalar (string or number); refs rejected.
  - `Params`: must be `ARRAY` or `HASH` (JSON array/object); scalar params rejected.
  - `Code`: integer only (regex `^-?\d+$`).
  - `Error`: `code` must be a `ValueObject::JSONRPC::Code` instance; `message` non-empty; `data` optional JSON.
  - `Result`: any JSON value (scalar, ARRAY, HASH, or null); reject non-JSON refs (glob/filehandles).

- Test authoring notes:
  - Tests use `Test2::V0`. Per-module tests commonly include `-target => 'ValueObject::JSONRPC::<Name>'`.
  - Use `like dies { ... }, qr/JSON-RPC .../` to assert validation messages.
  - Keep tests minimal and authoritative — they define acceptable types and exact die messages.

- Adding a new value object (quick scaffold):
  1. Create `lib/ValueObject/JSONRPC/YourThing.pm` following `Version.pm`.
  2. Add `t/value_object/jsonrpc/yourthing.t` with `Test2::V0 -target => 'ValueObject::JSONRPC::YourThing'`.
  3. Implement `value` accessor, `equals`, `overload '""'` if needed, and strict `isa` validation that dies with message fragments containing `JSON-RPC`.
  4. Run `prove -lr t`. Match CI to avoid surprises.
  5. If public API changes, bump `version->declare("vX.Y.Z")` in `lib/ValueObject/JSONRPC.pm` and add `Changes` entry.

If you want, I will now (re)attempt to apply this merge and fully replace the file with the integrated content. Proceed with updating the file?# GitHub Copilot / AI agent instructions for p5-ValueObject-JSONRPC

Short, concrete guidance so an AI can be productive immediately in this repo.

(keep existing content above; add the following AI-agent focused notes)

## AI-agent additions (discovered patterns & quick checklist)

- Inspect these files first when changing behavior:
  - lib/ValueObject/JSONRPC.pm (package entry / $VERSION)
  - lib/ValueObject/JSONRPC/Version.pm
  - lib/ValueObject/JSONRPC/MethodName.pm
  - lib/ValueObject/JSONRPC/Id.pm
  - lib/ValueObject/JSONRPC/Params.pm
  - lib/ValueObject/JSONRPC/Code.pm
  - lib/ValueObject/JSONRPC/Error.pm
  - lib/ValueObject/JSONRPC/Result.pm
  - Tests: t/value_object/jsonrpc/*.t

- Dev workflow (match CI exactly):
  - Install deps: `cpanm -nq --installdeps --with-develop --with-recommends .`
  - Run tests: `prove -lr t`
  - CI uses the same commands; use them locally to reproduce CI.

- Concrete conventions to follow:
  - Use `Moo` + `namespace::clean` for objects.
  - Constructors must `die` on invalid input; tests assert die-messages with regexes.
  - Provide `equals($other)` that accepts a scalar OR same-class instance; return `1`/`0`.
  - Implement stringification with `overload '""' => sub { $_[0]->value }` when appropriate.
  - Use `Storable::freeze` for deep equality comparisons (used in `Params`, `Result`, `Error->data`).

- VO-specific rules (explicit):
  - `Version`: only the exact string `'2.0'`.
  - `MethodName`: non-empty string; MUST NOT start with `rpc.`; reject pure-numeric scalars.
  - `Id`: allowed types: `undef` (null), non-ref scalar (string or number); refs rejected.
  - `Params`: must be `ARRAY` or `HASH` (JSON array/object); scalar params rejected.
  - `Code`: integer only (regex `^-?\d+$`).
  - `Error`: `code` must be a `ValueObject::JSONRPC::Code` instance; `message` non-empty; `data` optional JSON.
  - `Result`: any JSON value (scalar, ARRAY, HASH, or null); reject non-JSON refs (glob/filehandles).

- Test authoring notes:
  - Tests use `Test2::V0`. Per-module tests commonly include `-target => 'ValueObject::JSONRPC::<Name>'`.
  - Use `like dies { ... }, qr/JSON-RPC .../` to assert validation messages.
  - Keep tests minimal and authoritative — they define acceptable types and exact die messages.

- Adding a new value object (quick scaffold):
  1. Create `lib/ValueObject/JSONRPC/YourThing.pm` following `Version.pm`.
  2. Add `t/value_object/jsonrpc/yourthing.t` with `Test2::V0 -target => 'ValueObject::JSONRPC::YourThing'`.
  3. Implement `value` accessor, `equals`, `overload '""'` if needed, and strict `isa` validation that dies with message fragments containing `JSON-RPC`.
  4. Run `prove -lr t`. Match CI to avoid surprises.
  5. If public API changes, bump `version->declare("vX.Y.Z")` in `lib/ValueObject/JSONRPC.pm` and add `Changes` entry.
