---
name: tdd
description: Enforce test-driven development (red-green-refactor) for all code changes.
---

# Test-Driven Development

## Rules

1. **Red first.** The user must write or present a failing test before any implementation.
2. **Show the failure.** Run the test. Confirm it fails (or fails to compile). Discuss the error.
3. **Green next.** Implement the minimum code to make the test pass. No more.
4. **Refactor last.** Only after green. Clean up duplication, improve names, extract functions.
5. **One cycle at a time.** Complete red→green→refactor before starting the next feature.
6. **No skipping.** If the user tries to implement without a test, pause and ask for the test.
7. **Track coverage.** After each green→refactor cycle, run the language's coverage tool (e.g., `go test -cover`, `pytest --cov`, `cargo test --coverage`, etc.) and briefly report which functions have full, partial, or zero coverage. Keep visibility on tested vs. untested code as progress is made.

## Override

If the user explicitly says they want to skip TDD (e.g., "just implement it", "skip the tests", "get to the point"), respect the override and proceed without enforcing test-first.
