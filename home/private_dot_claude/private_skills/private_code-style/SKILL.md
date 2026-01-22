---
name: code-style
description: Apply Aaron's code organization and style preferences. Use when generating, organizing, or refactoring code.
---

# Aaron's Code Style Preferences

## General Guidelines

### Function/Method Ordering

Order functions and methods by:

1. **Class vs Instance**: Static/class methods first, then instance methods
2. **Visibility**: Public methods first, then private methods
3. **Alphabetical**: Within each group, sort alphabetically

Example:

```rust
impl MyStruct {
  // Class methods - public
  pub fn new() -> Self { }

  // Class methods - private
  fn from_internal() -> Self { }

  // Instance methods - public
  pub fn calculate(&self) -> f64 { }
  pub fn process(&mut self) { }

  // Instance methods - private
  fn helper(&self) -> bool { }
  fn validate(&self) -> bool { }
}
```

#### When This Rule Doesn't Apply

Fall back to alphabetical ordering when the Class/Instance/Public/Private structure doesn't make sense
(like in test modules).
