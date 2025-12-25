# GitHub Copilot / AI agent instructions for p5-ValueObject-JSONRPC

Short, concrete guidance so an AI can be productive immediately in this repo.

- Project purpose: a small Perl value-object distribution implementing JSON-RPC primitives. Primary modules:
  - lib/ValueObject/JSONRPC.pm — distribution/package entry (exports version in $VERSION)
  - lib/ValueObject/JSONRPC/Version.pm — the JSON-RPC `jsonrpc` version value object (core example)

- Big picture:
  - This is a single-purpose CPAN-style Perl module. The codebase follows the ValueObject pattern: immutable objects, read-only accessors, explicit validation in constructors.
  - Tests live in `t/` and drive expected behaviors. Follow the tests when changing behavior.

- Key files to read before making changes:
  - [lib/ValueObject/JSONRPC.pm](lib/ValueObject/JSONRPC.pm)
  - [lib/ValueObject/JSONRPC/Version.pm](lib/ValueObject/JSONRPC/Version.pm)
  - [t/value_object/jsonrpc/version.t](t/value_object/jsonrpc/version.t)
  - [cpanfile](cpanfile) (declares dev/runtime deps)
  - [.github/workflows/test.yml](.github/workflows/test.yml) (CI: installs deps with `cpanm` and runs `prove -lr t`)

- Testing & developer workflow (use these exact commands):
  - Install dependencies locally: `cpanm -nq --installdeps --with-develop --with-recommends .`
  - Run the test suite: `prove -lr t`
  - CI uses the same approach; match CI behavior to avoid surprises across Perl versions.

- Conventions and patterns to follow:
  - API style: use `Moo` for objects and `namespace::clean` for tidy symbols (see `Version.pm`).
  - Validation: constructors die on invalid values. Tests expect `dies`/`like dies { ... }` in `t/` files.
  - Equality: value objects implement an `equals` method that accepts either a plain string or another instance of the same class; return false for `undef` or other types.
  - Stringification: objects may overload `""` to return the scalar representation (see `overload '""' => sub { $_[0]->value }`).
  - Module versioning: use `version->declare("vX.Y.Z")` in the top-level module.

- Adding a new value object: mirror `ValueObject::JSONRPC::Version` structure
  - Place code under `lib/ValueObject/JSONRPC/YourThing.pm`.
  - Add tests under `t/value_object/jsonrpc/yourthing.t` following `Test2::V0` style used now.
  - Ensure constructor validation dies for invalid input and that equality/stringification semantics are covered in tests.

- Packaging notes:
  - Distribution uses `Build.PL` and contains `minil.toml`/`cpanfile`. CI installs deps with `cpanm` and runs `prove` (no `dzil` steps in CI).

- Examples from codebase:
  - Exact-version requirement: `ValueObject::JSONRPC::Version` accepts only the string `'2.0'` (see `isa` sub in `Version.pm` and tests in `t/.../version.t`).
  - Tests use `Test2::V0 -target => 'ValueObject::JSONRPC::Version'` and `prove -lr t` to run them.

- When editing tests or behavior:
  - Preserve the exact string-matching semantics (e.g., do not accept numeric `2` for version unless tests and docs are updated).
  - Update `lib/ValueObject/JSONRPC.pm` `$VERSION` consistently when making API changes.

- Ask the maintainer if unsure about:
  - Changing any fundamental validation rules (e.g., relaxing the '2.0' requirement).
  - Adding public APIs beyond simple value objects; this may require packaging/versioning discussion.

If any of these points are unclear or you want more examples to be included, tell me which area to expand. 
