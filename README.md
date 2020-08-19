# Flutterust

Flutter + Rust = :heart:

Using Rust libs from Flutter using [`dart:ffi`](https://dart.dev/guides/libraries/c-interop)

It provides out-of-the box support for cross-compiling native Rust code for all available iOS and Android architectures and call it from plain Dart using [Foreign Function Interface](https://en.wikipedia.org/wiki/Foreign_function_interface).

This template provides first class FFI support, **the clean way**.

- No Swift/Kotlin wrappers
- No message passing
- No async/await on Dart
- Write once, use everywhere
- No garbage collection
- Mostly automated development
- No need to export `aar` bundles or `.framework`'s

* If you are lookin on how to use this with async Rust, see [scrap](native/scrap-ffi/src/lib.rs) example (simple web scrapper).

## Project Structure

```
.
├── android
├── ios
├── lib                     <- The Flutter App Code
├── native                  <- Containes all the Rust Code
│   ├── adder
│   └── adder-ffi
├── packages                <- Containes all the Dart Packages that bind to the Rust Code
│   └── adder
├── target                  <- The compiled rust code for every arch
│   ├── aarch64-apple-ios
│   ├── aarch64-linux-android
│   ├── armv7-linux-androideabi
│   ├── debug
│   ├── i686-linux-android
│   ├── universal
│   ├── x86_64-apple-ios
│   └── x86_64-linux-android
└── test
```

## Setup and Tools

1. Add Rust build targets

#### For Android

```sh
rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android i686-linux-android
```

#### For iOS

```sh
rustup target add aarch64-apple-ios x86_64-apple-ios
```

2. Cargo Plugins

```sh
cargo install cargo-make
```

## Build and Test

In the Root of the project simply run:

```sh
cargo make
```

Then run flutter app normally

```
flutter run
```

## How it works?

The simple idea here is that we build our rust code for all supported targets
then build a Flutter Package that uses these targets.

##### In iOS

we build our rust package using [`cargo-lipo`](https://github.com/TimNN/cargo-lipo) to build a universal iOS static lib from our rust code
after that, we symbol link the built library to our package ios directory, copy the generated `bindgen.h` file to the `ios/Classes`
the `Makefile.toml` do these steps for us.

Next we need to add these lines to our package podspec file:

```rb
  s.public_header_files = 'Classes**/*.h'
  s.static_framework = true
  s.vendored_libraries = "**/*.a"
```

but Xcode dose some tree shaking and we currently not using our static lib anywhere in the code, so we open our package's `ios/Classes/Swift{PACKAGE_NAME}Plugin.swift` and add a dummy method there:

```swift
 public static func dummyMethodToEnforceBundling() {
    // call some function from our static lib
    add(40, 2)
  }
```

##### In Android

In android it is a bit simpler than iOS, we just need to symbol link some libs in the right place and that is it.
our build script creates this folder structure for every package we have:

```
packages/{PACKAGE_NAME}/android/src/main
├── jniLibs
│   ├── arm64-v8a
│   ├── armeabi-v7a
│   └── x86
```

Make sure that the Android NDK is installed (From SDK Manager in Android Studio), also ensure that the env variable `$ANDROID_NDK_HOME` points to the NDK base folder
and after that, the build script build our rust crate for all of these targets using [`cargo-ndk`](https://github.com/bbqsrc/cargo-ndk)
and symbol link our rust lib to the right place, and it just works :)

## See also

- [Dart Meets Rust: a match made in heaven ✨](https://dev.to/sunshine-chain/dart-meets-rust-a-match-made-in-heaven-9f5)
- [Dart and Rust: the async story 🔃](https://dev.to/sunshine-chain/rust-and-dart-the-async-story-3adk)
- https://github.com/brickpop/flutter-rust-ffi
- https://dart.dev/guides/libraries/c-interop
- https://flutter.dev/docs/development/platform-integration/c-interop
- https://github.com/dart-lang/samples/blob/master/ffi/structs/structs.dart
- https://mozilla.github.io/firefox-browser-architecture/experiments/2017-09-06-rust-on-ios.html
- https://mozilla.github.io/firefox-browser-architecture/experiments/2017-09-21-rust-on-android.html
