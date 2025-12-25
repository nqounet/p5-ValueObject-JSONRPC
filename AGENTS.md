AGENTS.md

Purpose

This file provides concise, actionable guidance for AI agents (e.g., GitHub Copilot CLI) working on the ValueObject-JSONRPC repository. It summarizes session findings and prescribes safe, reproducible workflows.

Session findings

- Tests
  - Run the full test suite with `prove -lr t`. In this session the suite passed: All tests PASS (14 files, 16 tests).

- Tool usage
  - Always include a `report_intent` call on the same tool-calling turn when invoking tools that modify repository state; use a short gerund intent (≤4 words), e.g., `Updating docs`.
  - Choose appropriate execution modes (sync/async/detached) and set reasonable `initial_wait` durations for long-running commands.

- Documentation & automation
  - Document how to reproduce CI locally: `cpanm -nq --installdeps --with-develop --with-recommends .` then `prove -lr t`.

Recommendations

- Testing and changes
  - Run `prove -lr t` locally before proposing or committing changes.
  - Keep changes minimal and surgical; add tests under `t/` for new behavior.

- Coding conventions and expectations
  - Follow repository conventions: use Moo + namespace::clean, implement `equals()`, and use `Storable::freeze` for deep comparisons where required.
  - Respect ValueObject validation rules (Version == '2.0', MethodName constraints, allowed types for Id/Params/Code/Error/Result, etc.).

- Releases and API changes
  - When making public API changes, bump the version in `lib/ValueObject/JSONRPC.pm` and record the change in Changes/META files.

Notes

- AGENTS.md is the authoritative agent guidance; `.github/copilot-instructions.md` delegates to this file.
- If unclear, open an issue or ask for clarification before making breaking changes.
