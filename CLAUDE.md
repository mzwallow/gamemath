# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Zig library + CLI project using module system to separate reusable code from executable.

## Commands

| Command | Description |
|---------|-------------|
| `zig build` | Build project |
| `zig build run [-- args]` | Run executable |
| `zig build test` | Run all tests |
| `zig build test -- --fuzz` | Run tests with fuzzing |
| `zig build --help` | View available steps |
| `zig build -p [path]` | Install to prefix (default: `zig-out/`) |

## Architecture

```
src/
  root.zig    # Library module entry point (exposed as "gamemath")
  main.zig    # CLI executable entry point
  math/
    vec.zig    # Vector math module (Vec2, Vec3, Vec4)
    precision.zig # Real type, EPSILON, and floating-point comparison helpers
build.zig     # Build configuration
```

**Module System**: Library (`root.zig`) is exposed as module `gamemath`. Executable (`main.zig`) imports it. Both have separate test suites running in parallel via `test_step`.

To expose library functions: define in any `src/*.zig`, then re-export from `root.zig` using `pub`.

Adding modules to executable: add to `imports` array in `b.createModule` call (build.zig:75-82).

## Testing

Zig uses inline test blocks: `test "description" { ... }`.

| Command | Description |
|---------|-------------|
| `zig build test` | Run all tests across project in parallel |
| `zig test src/module.zig` | Test single module directly |

Use `std.testing.expect()` for boolean assertions, `std.testing.expectEqual()` for value equality.
Use `std.testing.fuzz()` for property-based testing with `--fuzz` flag.

## Gotchas

- **Always `defer deinit()`**: ArrayList and other allocated structures leak without explicit cleanup
- **Namespace imports**: Use `const name = @import("file.zig")` pattern for same-directory imports, then access via `name.Type` or `name.constant`
- **Flush buffered writers**: stdout Writer buffers 1024 bytes by default; call `flush()` before exit
- **Error handling**: Use `try` for bubble-up, `trycatch` only when handling the error
- **Module imports**: Only declarations in `root.zig` are visible to library consumers

## Commit Conventions

Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`

**Examples**:
```
feat(math): add vector multiplication
fix: resolve buffer overflow in print
docs: update installation instructions
```

## Minimum Zig Version

Requires Zig 0.15.2+ (specified in `build.zig.zon`).

## Development Guidelines

- **User writes all implementation code**: Explain concepts and guide decisions, but let the user write the actual code. Do not use Edit/Write tools for implementations unless explicitly requested.
- **Always use `AskUserQuestion`**: When facing design decisions, multiple valid approaches, or unclear requirements, ask the user rather than assuming
