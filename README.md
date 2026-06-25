# Swiftlings (Linux)

Small exercises to learn Swift, the way [Rustlings](https://github.com/rust-lang/rustlings)
teaches Rust. You fix one broken file at a time, save it, and the runner checks
your work and moves you to the next one. This fork is set up to run on **Linux**,
with a Nix flake that pins a working Swift toolchain so you do not have to fight
the setup before you get to learn.

Every exercise links to the matching chapter of
[The Swift Programming Language](https://docs.swift.org/swift-book/), so you can
read the official explanation right when you need it.

## Quick start

### With Nix (recommended)

The flake brings its own Swift 5.10.1 toolchain and everything it needs, so this
is the path that just works:

```sh
git clone <this-repo> swiftlings && cd swiftlings
nix develop          # or: direnv allow, if you use direnv
swiftlings           # start in watch mode
```

`swiftlings` is an alias the dev shell sets up for `swift run swiftlings`.

### With your own Swift toolchain

If you already have Swift 5.9 or newer from [swift.org](https://www.swift.org/install/),
you do not need Nix at all:

```sh
git clone <this-repo> swiftlings && cd swiftlings
swift run swiftlings
```

## How it works

You always work on the first exercise you have not solved yet. Open its file, fix
the compiler or logic error, and save. In watch mode the runner recompiles and
reruns it for you. An exercise is solved when it **compiles and all of its checks
pass**.

Commands:

| Command              | What it does                                         |
| -------------------- | ---------------------------------------------------- |
| `swiftlings`         | Watch mode: solve, save, repeat                      |
| `swiftlings list`    | Every exercise and your progress                     |
| `swiftlings run`     | Run the current exercise once (or `run NAME`)        |
| `swiftlings hint`    | A hint, plus a link to the relevant Swift book page  |
| `swiftlings reset`   | Put an exercise back to its starting state           |

In watch mode you can also press `h` for a hint, `l` to list, `n` to move on once
the current one passes, `r` to rerun, and `q` to quit.

## Topics

The exercises build up from the basics to the deeper parts of the language:

`00_basics` · `01_control_flow` · `02_functions` · `03_collections` ·
`04_optionals` · `05_structs` · `06_classes` · `07_enums` · `08_protocols` ·
`09_extensions` · `10_generics` · `11_error_handling` · `12_closures` ·
`13_memory_management` · `14_property_wrappers` · `15_concurrency` ·
`16_result_builders` · `17_advanced_types` · `18_codable`, plus a small
data-structures track that builds a queue from scratch.

Each topic folder has a `README.md` with a short explanation and links to the
official docs. Read it before you start the exercises in that folder.

## Notes on the Linux port

The runner started life as a macOS-focused project. Getting it to build and run
cleanly on Linux with the nixpkgs Swift 5.10.1 toolchain took a few fixes worth
writing down:

- `JSONEncoder` with the `.iso8601` date strategy crashes hard on Linux's
  swift-corelibs-foundation. Progress is stored with epoch seconds instead.
- The hardcoded `/usr/bin/swiftc` and `/usr/bin/git` paths are resolved from
  `PATH` so the toolchain is found wherever it lives.
- Raw terminal input needs `import Glibc` on Linux, and one helper that relied on
  the macOS `fd_set` layout was unused and removed.
- The unit tests were written against swift-testing, which the pinned toolchain
  cannot build, so they were converted to XCTest.

One thing still does not work on this exact nix pin: `swift test`. The nixpkgs
Swift 5.10.1 build is missing `libIndexStore.so`, which SwiftPM needs to assemble
the test bundle. The tests are fine and run on a stock swift.org toolchain (and in
CI); they just cannot run under this specific Nix package. Plain `swift build` and
the runner itself are not affected.

## Credits

- [Swiftlings](https://github.com/tornikegomareli/swiftlings) by Tornike Gomareli,
  the original Swift exercise runner and exercises this fork is built on (MIT).
- [Rustlings](https://github.com/rust-lang/rustlings), the Rust project that
  started this whole idea (MIT).

## License

MIT. See [LICENSE](LICENSE).
