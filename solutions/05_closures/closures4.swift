// closures4.swift
//
// Advanced closure patterns including builders and DSLs.
// Trailing closure syntax with multiple closures.
//
// Fix the advanced closure patterns to make the tests pass.

import Foundation

// A class (reference type) so the nested tag/text closures all append to the
// same buffer.
class HTMLBuilder {
    private var html = ""

    func build() -> String {
        return html
    }

    func tag(_ name: String, closure: () -> Void) {
        html += "<\(name)>"
        closure()
        html += "</\(name)>"
    }

    func text(_ content: String) {
        html += content
    }
}

func buildHTML(_ builder: (HTMLBuilder) -> Void) -> String {
    let htmlBuilder = HTMLBuilder()
    builder(htmlBuilder)
    return htmlBuilder.build()
}

func animate(
    duration: Double,
    animations: () -> Void,
    completion: @escaping () -> Void
) {
    animations()
    DispatchQueue.global().asyncAfter(deadline: .now() + duration) {
        completion()
    }
}

struct Configuration {
    var name: String = ""
    var value: Int = 0
    var enabled: Bool = false
}

func configure(_ config: inout Configuration, using closure: (inout Configuration) -> Void) {
    closure(&config)
}

@resultBuilder
struct ArrayBuilder<Element> {
    static func buildExpression(_ expression: Element) -> [Element] {
        return [expression]
    }

    static func buildBlock(_ components: [Element]...) -> [Element] {
        return components.flatMap { $0 }
    }

    static func buildOptional(_ component: [Element]?) -> [Element] {
        return component ?? []
    }

    static func buildEither(first component: [Element]) -> [Element] {
        return component
    }

    static func buildEither(second component: [Element]) -> [Element] {
        return component
    }
}

func buildArray<T>(@ArrayBuilder<T> _ builder: () -> [T]) -> [T] {
    return builder()
}

func main() {
    print(buildHTML { builder in builder.text("hello") })

    test("HTML DSL") {
        let html = buildHTML { builder in
            builder.tag("div") {
                builder.tag("h1") {
                    builder.text("Hello")
                }
                builder.tag("p") {
                    builder.text("World")
                }
            }
        }

        assertEqual(html, "<div><h1>Hello</h1><p>World</p></div>",
                   "Nested HTML structure")
    }

    test("Multiple trailing closures") {
        var animationRan = false
        var completionRan = false
        let expectation = DispatchSemaphore(value: 0)

        animate(duration: 0.1) {
            animationRan = true
        } completion: {
            completionRan = true
            expectation.signal()
        }

        assertTrue(animationRan, "Animation closure ran")

        expectation.wait()
        assertTrue(completionRan, "Completion closure ran")
    }

    test("Configuration DSL") {
        var config = Configuration()

        configure(&config) { cfg in
            cfg.name = "MyConfig"
            cfg.value = 42
            cfg.enabled = true
        }

        assertEqual(config.name, "MyConfig", "Name configured")
        assertEqual(config.value, 42, "Value configured")
        assertTrue(config.enabled, "Enabled configured")
    }

    test("Result builder") {
        let numbers = buildArray {
            1
            2
            3
        }

        assertEqual(numbers, [1, 2, 3], "Build array of numbers")

        let conditional = buildArray {
            "Hello"
            if true {
                "World"
            }
            if false {
                "Hidden"
            }
        }

        assertEqual(conditional, ["Hello", "World"], "Conditional building")
    }

    test("Complex DSL usage") {
        let result = buildHTML { html in
            html.tag("ul") {
                let items = ["Apple", "Banana", "Cherry"]
                for item in items {
                    html.tag("li") {
                        html.text(item)
                    }
                }
            }
        }

        assertEqual(result, "<ul><li>Apple</li><li>Banana</li><li>Cherry</li></ul>",
                   "Dynamic HTML generation")
    }

    runTests()
}
