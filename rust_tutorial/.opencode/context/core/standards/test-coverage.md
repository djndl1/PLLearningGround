# Rust Tutorial Test Standards

## Overview
Simple testing standards for the Rust Tutorial project. Focus on basic testing to help learn Rust.

## Testing Philosophy

### Primary Goals
- Learn how to test in Rust
- Catch basic errors
- Understand test structure
- Practice Rust testing patterns

### Simple Testing Approach
- Write basic tests for functions
- Test common cases
- Learn test syntax
- Practice with real examples

## Test Structure

### Simple Test Organization
```rust
// In lib.rs - basic tests
#[cfg(test)]
mod tests {
    #[test]
    fn test_add() {
        // Test implementation
    }
    
    #[test]
    fn test_hello() {
        // Test implementation
    }
}

// In tests/ - integration tests
use rust_tutorial::add;

#[test]
fn test_integration() {
    // Integration test
}
```

## Test Writing Standards

### Simple Test Naming
```rust
// Good - clear and simple
#[test]
fn test_add_function() {
    // Test add function
}

#[test]
fn test_hello_prints() {
    // Test hello function
}

// Bad - too vague
#[test]
fn test() {
    // What does this test?
}
```

### Simple Test Structure
```rust
// Simple Arrange-Act-Assert
#[test]
fn test_add() {
    let result = add(2, 3);
    assert_eq!(result, 5);
}

// Simple test with setup
#[test]
fn test_guessing_game() {
    // Test game logic
    // Simple assertions
}
```

## Test Coverage Requirements

### Basic Coverage
- Test main functions
- Test common cases
- Test error conditions
- Test edge cases

### Simple Metrics
- At least 1 test per public function
- Test basic functionality
- Test error handling

## Test Quality Standards

### Test Clarity
```rust
// Good - clear purpose
#[test]
fn test_add_two_numbers() {
    // Test that adding two numbers works correctly
}

// Bad - unclear
#[test]
fn test_something() {
    // What does this test?
}
```

### Test Independence
- Each test should work alone
- No shared state between tests
- Simple and isolated

## Error Handling Tests

### Basic Panic Tests
```rust
#[test]
#[should_panic]
fn test_function_that_panics() {
    // Test that function panics as expected
}
```

## Integration Test Standards

### Simple Integration Tests
```rust
// tests/integration_tests.rs
use rust_tutorial::add;

#[test]
fn test_add_integration() {
    assert_eq!(add(1, 2), 3);
}
```

## Testing Educational Value

### Teaching Testing Concepts
```rust
#[test]
fn test_basic_assertion() {
    // Learn assert! macro
    assert!(true);
}

#[test]
fn test_compare_values() {
    // Learn assert_eq! macro
    assert_eq!(1 + 1, 2);
}
```

## Simple Test Automation

### Basic CI/CD
```yaml
name: Rust Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Run tests
      run: cargo test
```

## References
- [The Rust Book - Testing](https://doc.rust-lang.org/book/ch11-02-testing.html)
- [Testing in Rust](https://testing.rust-lang.org/)