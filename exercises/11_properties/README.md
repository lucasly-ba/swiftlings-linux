# Properties

This section covers Swift's properties: stored and computed properties, property
observers, lazy properties, and type (static) properties.

## Official Swift Documentation
- [Properties - The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties)
- [Computed Properties - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties#Computed-Properties)
- [Property Observers - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties#Property-Observers)
- [Type Properties - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties#Type-Properties)

In this section, you'll learn about:
- Stored vs computed properties
- The `willSet` and `didSet` observers
- `lazy` stored properties
- `static` properties and methods

## Key Concepts

### Computed properties
A computed property has no storage. It runs a `{ }` block to produce its value
from other properties every time it is read.

### Lazy and static
A `lazy` property is built on first use. `static` members belong to the type
itself and are shared by every instance.

## Further Information

- [Lazy Stored Properties](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties#Lazy-Stored-Properties)
- [Property Observers](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties#Property-Observers)
