# OneTimePassword Changelog

## [In development][develop]

- Drop support for Swift 4.2
  ([#229](https://github.com/mattrubin/OneTimePassword/pull/229))
- Drop CocoaPods support
  ([#249](https://github.com/mattrubin/OneTimePassword/pull/249))
- Add SPM support
  ([#221](https://github.com/mattrubin/OneTimePassword/pull/221))
- Bump deployment targets to iOS 13.0, macOS 10.15, and watchOS 6.0
  ([#245](https://github.com/mattrubin/OneTimePassword/pull/245))
- Replace optional initializers with throwing initializers
  ([#254](https://github.com/mattrubin/OneTimePassword/pull/254))
- Use CryptoKit instead of CommonCrypto for HMAC generation
  ([#214](https://github.com/mattrubin/OneTimePassword/pull/214),
  [#230](https://github.com/mattrubin/OneTimePassword/pull/230),
  [#244](https://github.com/mattrubin/OneTimePassword/pull/244),
  [#245](https://github.com/mattrubin/OneTimePassword/pull/245),
  [#256](https://github.com/mattrubin/OneTimePassword/pull/256))
- Modernize project and tooling configurations
  ([#228](https://github.com/mattrubin/OneTimePassword/pull/228),
  [#252](https://github.com/mattrubin/OneTimePassword/pull/252),
  [#253](https://github.com/mattrubin/OneTimePassword/pull/253))
- Migrate CI from Travis to GitHub Actions
  ([#231](https://github.com/mattrubin/OneTimePassword/pull/231),
  [#232](https://github.com/mattrubin/OneTimePassword/pull/232),
  [#243](https://github.com/mattrubin/OneTimePassword/pull/243),
  [#246](https://github.com/mattrubin/OneTimePassword/pull/246),
  [#251](https://github.com/mattrubin/OneTimePassword/pull/251))
- Upgrade dependencies
  ([#241](https://github.com/mattrubin/OneTimePassword/pull/241),
  [#233](https://github.com/mattrubin/OneTimePassword/pull/233),
  [#248](https://github.com/mattrubin/OneTimePassword/pull/248))

## [3.2.0][] (2019-09-20)

- Upgrade the source to compile with both Swift 4.2 and Swift 5.
  ([#201](https://github.com/mattrubin/OneTimePassword/pull/201),
   [#202](https://github.com/mattrubin/OneTimePassword/pull/202),
   [#204](https://github.com/mattrubin/OneTimePassword/pull/204),
   [#209](https://github.com/mattrubin/OneTimePassword/pull/209),
   [#215](https://github.com/mattrubin/OneTimePassword/pull/215),
   [#216](https://github.com/mattrubin/OneTimePassword/pull/216))
- Update the SwiftLint configuration, and move the SwiftLint build phase to a separate dedicated target so that new lint errors do not interfere with consumers of the framework.
  ([#212](https://github.com/mattrubin/OneTimePassword/pull/212),
   [#206](https://github.com/mattrubin/OneTimePassword/pull/206))
- Upgrade xcconfigs to enable new warnings introduced in Xcode 10.2
  ([#203](https://github.com/mattrubin/OneTimePassword/pull/203))

## [3.1.5][] (2019-04-11)
- Enable additional linting and CI testing.
([#196](https://github.com/mattrubin/OneTimePassword/pull/196),
[#192](https://github.com/mattrubin/OneTimePassword/pull/192))
- Satisfy various project-level warnings introduced in Xcode 10.2.
([#198](https://github.com/mattrubin/OneTimePassword/pull/198))

## [3.1.4][] (2018-09-15)
- Fix compilation errors and add CI testing for Xcode 10.
([#182](https://github.com/mattrubin/OneTimePassword/pull/182),
[#186](https://github.com/mattrubin/OneTimePassword/pull/186))
- Enable several new SwiftLint opt-in rules. ([#187](https://github.com/mattrubin/OneTimePassword/pull/187))


## [3.1.3][] (2018-04-29)
- Ignore un-deserializable tokens in `allPersistentTokens()`. ([#179](https://github.com/mattrubin/OneTimePassword/pull/179))


## [3.1.2][] (2018-04-23)
- Synthesize Equatable conformance when compiling with Swift 4.1. ([#173](https://github.com/mattrubin/OneTimePassword/pull/173))
- Fix a warning about deprecation of cross-module struct initializers by simplifying test cases for impossible-to-create invalid Generators. ([#174](https://github.com/mattrubin/OneTimePassword/pull/174))
- Upgrade xcconfigs for Xcode 9.3. ([#172](https://github.com/mattrubin/OneTimePassword/pull/172))
- Enable several new SwiftLint opt-in rules. ([#175](https://github.com/mattrubin/OneTimePassword/pull/175))


## [3.1.1][] (2018-03-31)
- Add support for Swift 4.1. ([#168](https://github.com/mattrubin/OneTimePassword/pull/168))
- Update build and linter settings for Xcode 9.3. ([#167](https://github.com/mattrubin/OneTimePassword/pull/167))


## [3.1][] (2018-03-27)
- Upgrade to Swift 4 and Xcode 9.
([#147](https://github.com/mattrubin/OneTimePassword/pull/147),
[#149](https://github.com/mattrubin/OneTimePassword/pull/149),
[#151](https://github.com/mattrubin/OneTimePassword/pull/151),
[#153](https://github.com/mattrubin/OneTimePassword/pull/153),
[#160](https://github.com/mattrubin/OneTimePassword/pull/160))
- Handle keychain deserialization errors.
([#161](https://github.com/mattrubin/OneTimePassword/pull/161))
- Refactor token URL parsing.
([#150](https://github.com/mattrubin/OneTimePassword/pull/150))
- Refactor Generator validation.
([#155](https://github.com/mattrubin/OneTimePassword/pull/155))
- Update SwiftLint configuration and improve code formatting.
([#148](https://github.com/mattrubin/OneTimePassword/pull/148),
[#154](https://github.com/mattrubin/OneTimePassword/pull/154),
[#159](https://github.com/mattrubin/OneTimePassword/pull/159))
- Update CodeCov configuration.
([#162](https://github.com/mattrubin/OneTimePassword/pull/162))


## [3.0.1][] (2018-03-08)
- Fix an issue where CocoaPods was trying to build OneTimePassword with Swift 4. ([#157](https://github.com/mattrubin/OneTimePassword/pull/157))
- Fix the Base32-decoding function in the token creation example code. ([#134](https://github.com/mattrubin/OneTimePassword/pull/134))
- Tweak the Travis CI configuration to work around test timeout flakiness. ([#131](https://github.com/mattrubin/OneTimePassword/pull/131))
- Clean up some old Keychain code which was used to provide Xcode 7 backwards compatibility. ([#133](https://github.com/mattrubin/OneTimePassword/pull/133))


## [3.0][] (2017-02-07)
- Convert to Swift 3 and update the library API to follow the Swift [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).
([#74](https://github.com/mattrubin/OneTimePassword/pull/74),
[#78](https://github.com/mattrubin/OneTimePassword/pull/78),
[#80](https://github.com/mattrubin/OneTimePassword/pull/80),
[#91](https://github.com/mattrubin/OneTimePassword/pull/91),
[#100](https://github.com/mattrubin/OneTimePassword/pull/100),
[#111](https://github.com/mattrubin/OneTimePassword/pull/111),
[#113](https://github.com/mattrubin/OneTimePassword/pull/113),
[#122](https://github.com/mattrubin/OneTimePassword/pull/122),
[#123](https://github.com/mattrubin/OneTimePassword/pull/123),
[#125](https://github.com/mattrubin/OneTimePassword/pull/125))
- Convert `password(at:)` to take a `Date` instead of a `TimeInterval`. ([#124](https://github.com/mattrubin/OneTimePassword/pull/124))
- Update the SwiftLint configuration. ([#120](https://github.com/mattrubin/OneTimePassword/pull/120))


## [2.1.1][] (2016-12-28)
- Configure Travis to build and test with Xcode 8.2. ([#115](https://github.com/mattrubin/OneTimePassword/pull/115))
- Add a test host app to enable keychain tests on iOS 10. ([#116](https://github.com/mattrubin/OneTimePassword/pull/116))
- Update the SwiftLint configuration for SwiftLint 0.15. ([#117](https://github.com/mattrubin/OneTimePassword/pull/117))


## [2.1][] (2016-11-16)
#### Enhancements
- Add watchOS support. ([#96](https://github.com/mattrubin/OneTimePassword/pull/96), [#98](https://github.com/mattrubin/OneTimePassword/pull/98), [#107](https://github.com/mattrubin/OneTimePassword/pull/107))
- Inject Xcode path into the CommonCrypto modulemaps, to support non-standard Xcode locations. ([#92](https://github.com/mattrubin/OneTimePassword/pull/92), [#101](https://github.com/mattrubin/OneTimePassword/pull/101))

#### Other Changes
- Clean up project configuration and build settings. ([#95](https://github.com/mattrubin/OneTimePassword/pull/95), [#97](https://github.com/mattrubin/OneTimePassword/pull/97))
- Improve instructions and project settings to make setting up a new clone easier. ([#104](https://github.com/mattrubin/OneTimePassword/pull/104))
- Add tests for validation and parsing failures. ([#105](https://github.com/mattrubin/OneTimePassword/pull/105))
- Improve documentation comments. ([#108](https://github.com/mattrubin/OneTimePassword/pull/108))
- Refactor the Keychain tests to remove excessive nesting. ([#109](https://github.com/mattrubin/OneTimePassword/pull/109))


## [2.0.1][] (2016-09-20)
#### Enhancements
- Update the project to support Xcode 8 and Swift 2.3. ([#73](https://github.com/mattrubin/OneTimePassword/pull/73), [#75](https://github.com/mattrubin/OneTimePassword/pull/75), [#84](https://github.com/mattrubin/OneTimePassword/pull/84))

#### Fixes
- Disable broken keychain tests on iOS 10. ([#77](https://github.com/mattrubin/OneTimePassword/pull/77), [#88](https://github.com/mattrubin/OneTimePassword/pull/88))

#### Other Changes
- Update badge images and links in the README. ([#69](https://github.com/mattrubin/OneTimePassword/pull/69))
- Reorganize source and test files following the conventions the Swift Package Manager. ([#70](https://github.com/mattrubin/OneTimePassword/pull/70))
- Isolate the CommonCrypto dependency inside a custom wrapper function. ([#71](https://github.com/mattrubin/OneTimePassword/pull/71))
- Clean up whitespace. ([#79](https://github.com/mattrubin/OneTimePassword/pull/79))
- Integrate with codecov.io for automated code coverage reporting. ([#82](https://github.com/mattrubin/OneTimePassword/pull/82))
- Update SwiftLint configuration. ([#87](https://github.com/mattrubin/OneTimePassword/pull/87))
- Update Travis configuration to use Xcode 8. ([#89](https://github.com/mattrubin/OneTimePassword/pull/89))


## [2.0.0][] (2016-02-07)

Version 2 of the OneTimePassword library has been completely redesigned and rewritten with a modern Swift API. The new library source differs too greatly from its predecessor for the changes to be representable in a changelog. The README has a usage guide for the new API.

Additional changes of note:
- The library is well-tested and the source fully documented.
- Carthage is used to manage dependencies, which are checked in as Git submodules.
- Travis CI is used for testing, and Hound CI for linting.
- The project now has a detailed README, as well as a changelog, guidelines for contributing, and a code of conduct.

Changes between prerelease versions of OneTimePassword version 2 can be found below.

### [2.0.0-rc][] (2016-02-07)
- Update `Token` tests for full test coverage. (#66)
- Add installation and usage instructions to the README. (#63, #65, #67)
- Upgrade the Travis build configuration to use Xcode 7.2 and iOS 9.2. (#66)
- Add a README file to the CommonCrypto folder to explain the custom modulemaps. (#64)
- Assorted cleanup and formatting improvements. (#61, #62)

### [2.0.0-beta.5][] (2016-02-05)
- Use custom `modulemap`s to link CommonCrypto, removing external dependency on `soffes/Crypto` (#57)
- Make `jspahrsummers/xcconfigs` a private dependency. (#58)
- Update `OneTimePassword.podspec` to build the new framework. (#59)

### [2.0.0-beta.4][] (2016-02-04)
- Refactor and document new Swift framework
- Remove legacy Objective-C framework
- Add framework dependency for CommonCrypto
- Improve framework tests

### [2.0.0-beta.3][] (2015-02-03)
- Add documentation comments to `Token` and `Generator`
- Add static constants for default values
- Remove useless convenience initializer from `OTPToken`

### [2.0.0-beta.2][] (2015-02-01)
- Fix compatibility issues in OneTimePasswordLegacy
- Build and link dependencies directly, instead of relying on a pre-built framework

### [2.0.0-beta.1][] (2015-02-01)
- Refactor `OTPToken` to prevent issues when creating invalid tokens
- Improve testing of legacy tokens with invalid timer period or digits
- Turn off Swift optimizations in Release builds (to avoid a keychain access issue)

### [2.0.0-beta][] (2015-01-26)
- Convert the library to Swift and compile it into a Framework bundle for iOS 8+.
- Replace CocoaPods with Carthage for dependency management.

## [1.1.1][] (2015-12-05)
- Bump deployment target to iOS 8 (the framework product was already unsupported on iOS 7) (#46, #48)
- Replace custom query string parsing and escaping with iOS 8's `NSURLQueryItem`. (#47)
- Add `.gitignore` (#46)
- Configure for Travis CI, adding `.travis.yml` and sharing `OneTimePassword.xcscheme` (#46)
- Update `Podfile` and check in the CocoaPods dependencies. (#46)
- Update `.xcodeproj` version and specify project defaults for indentation and prefixing. (#49)
- Add `README` with project description and a note linking to the latest version of the project (#50)

## [1.1.0][] (2014-07-23)

## [1.0.0][] (2014-07-17)

[develop]: https://github.com/mattrubin/OneTimePassword/compare/3.2.0...develop

[3.2.0]: https://github.com/mattrubin/OneTimePassword/compare/3.1.5...3.2.0
[3.1.5]: https://github.com/mattrubin/OneTimePassword/compare/3.1.4...3.1.5
[3.1.4]: https://github.com/mattrubin/OneTimePassword/compare/3.1.3...3.1.4
[3.1.3]: https://github.com/mattrubin/OneTimePassword/compare/3.1.2...3.1.3
[3.1.2]: https://github.com/mattrubin/OneTimePassword/compare/3.1.1...3.1.2
[3.1.1]: https://github.com/mattrubin/OneTimePassword/compare/3.1...3.1.1
[3.1]: https://github.com/mattrubin/OneTimePassword/compare/3.0.1...3.1
[3.0.1]: https://github.com/mattrubin/OneTimePassword/compare/3.0...3.0.1
[3.0]: https://github.com/mattrubin/OneTimePassword/compare/2.1.1...3.0
[2.1.1]: https://github.com/mattrubin/OneTimePassword/compare/2.1...2.1.1
[2.1]: https://github.com/mattrubin/OneTimePassword/compare/2.0.1...2.1
[2.0.1]: https://github.com/mattrubin/OneTimePassword/compare/2.0.0...2.0.1
[2.0.0]: https://github.com/mattrubin/OneTimePassword/compare/1.1.0...2.0.0
[2.0.0-rc]: https://github.com/mattrubin/OneTimePassword/compare/2.0.0-beta.5...2.0.0
[2.0.0-beta.5]: https://github.com/mattrubin/OneTimePassword/compare/2.0.0-beta.4...2.0.0-beta.5
[2.0.0-beta.4]: https://github.com/mattrubin/OneTimePassword/compare/2.0.0-beta.3...2.0.0-beta.4
[2.0.0-beta.3]: https://github.com/mattrubin/OneTimePassword/compare/2.0.0-beta.2...2.0.0-beta.3
[2.0.0-beta.2]: https://github.com/mattrubin/OneTimePassword/compare/2.0.0-beta.1...2.0.0-beta.2
[2.0.0-beta.1]: https://github.com/mattrubin/OneTimePassword/compare/2.0.0-beta...2.0.0-beta.1
[2.0.0-beta]: https://github.com/mattrubin/OneTimePassword/compare/1.1.1...2.0.0-beta
[1.1.1]: https://github.com/mattrubin/OneTimePassword/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/mattrubin/OneTimePassword/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/mattrubin/OneTimePassword/tree/1.0.0
