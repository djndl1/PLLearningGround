# AGENTS.md

## Quick Start

**This is a Rust tutorial project** - code examples teach Rust concepts, not just build a product.

### Core Commands
```bash
# Build everything
cargo build

# Run all tests (unit + integration)
cargo test

# Run specific test
cargo test --test integration_tests

# Run a binary example
cargo run --bin hello
cargo run --bin guessing_game

# Check code formatting
cargo fmt -- --check

# Run linter
cargo clippy
```

### Project Structure
```
src/
├── lib.rs              # Library with add() function and unit tests
└── bin/
    ├── hello.rs        # Simple "Hello, test!" program
    └── guessing_game.rs # Interactive number guessing game (1-100)

tests/
└── integration_tests.rs # Integration test for add() function
```

### Key Files & Purpose
- **`src/lib.rs`**: Teaches basic Rust functions, testing (`#[test]`), and panic handling (`#[should_panic]`)
- **`src/bin/hello.rs`**: Simplest possible Rust program - entry point learning
- **`src/bin/guessing_game.rs`**: Complex example showing:
  - Random number generation with `rand`
  - Input parsing with error handling
  - Pattern matching with `match`
  - Control flow and game logic
- **`tests/integration_tests.rs`**: Integration test using `use rust_tutorial::add`

### Dependencies
- **`rand = "0.9.2"`**: For random number generation in guessing game
- **`trpl = "0.2.0"`**: Likely for async/tokio examples (not used in current code)

### Testing Approach
- **Unit tests** in `src/lib.rs` (3 tests): `it_works()`, `print_test()`, `should_panic_test()`
- **Integration tests** in `tests/` directory: Tests library functions from outside

### Code Organization
- **Library code** (`src/lib.rs`): Reusable functions, contains tests
- **Binary examples** (`src/bin/`): Complete programs for learning
- **Tests** (`tests/`): Integration tests that use library functions

### Educational Focus
This project teaches:
- Basic Rust syntax and functions
- Standard library usage (`rand`, `std::cmp`, `std::io`)
- Error handling with `match` expressions
- Testing framework integration (`#[test]`, `#[should_panic]`)
- Binary vs library separation
- Integration testing

### Common Workflow
1. **Learn** from examples in `src/bin/`
2. **Test** with `cargo test`
3. **Run** examples with `cargo run --bin <name>`
4. **Understand** concepts from `src/lib.rs` tests

### Notes
- Edition 2024 (modern Rust)
- Simple, educational code (not production-ready)
- Focus on teaching Rust concepts over best practices
- Each file demonstrates specific Rust patterns for learning