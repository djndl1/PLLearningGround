# Rust Tutorial Code Standards

## Overview
Simple code standards for the Rust Tutorial project. Focus on learning Rust with clear, working examples.

## Rust Version
- **Edition:** 2024
- **Tool:** `cargo` for building

## Code Structure

### Simple Organization
```
src/
├── lib.rs              # Library with functions
└── bin/                # Example programs
    ├── hello.rs        # Simple example
    └── guessing_game.rs # Interactive example

tests/
└── integration_tests.rs # Integration tests
```

## Code Style

### Basic Formatting
- **Indentation:** 4 spaces
- **Comments:** Use `//` for comments
- **Naming:** Simple, clear names

### Function Examples
```rust
// Simple public function
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

// Simple main function
fn main() {
    println!("Hello, Rust!");
}
```

### Error Handling
- Use `match` for simple error handling
- Use `expect()` for learning
- Handle common cases

## Documentation

### Simple Comments
```rust
// Add two numbers
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

// Print greeting
fn main() {
    println!("Hello, Rust!");
}
```

## Educational Focus

### Learning Goals
- Show basic Rust syntax
- Demonstrate common patterns
- Provide working examples
- Teach error handling

### Code Quality
- Clear and simple
- Working examples
- Good comments
- Basic error handling

## Build and Testing

### Cargo Setup
```toml
[package]
name = "rust_tutorial"
version = "0.1.0"
edition = "2024"

[dependencies]
rand = "0.9.2"
```

### Testing
- Write basic tests
- Test common cases
- Learn test syntax
- Practice with examples

## Examples

### Good Example
```rust
use std::{cmp::Ordering, io};

pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

fn main() {
    let secret_number = rand::rng().random_range(1..=100);
    
    loop {
        let mut guess = String::new();
        io::stdin().read_line(&mut guess).expect("read error");
        
        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => {
                println!("Not a number!");
                continue;
            }
        };
        
        match guess.cmp(&secret_number) {
            Ordering::Less => println!("Too small"),
            Ordering::Equal => {
                println!("You win!");
                break;
            }
            Ordering::Greater => println!("Too big"),
        }
    }
}
```

### Bad Example
```rust
// No error handling
let x = parse_number();

// No comments
fn bad() {
    // Unclear what this does
}
```

## References
- [The Rust Book](https://doc.rust-lang.org/book/)