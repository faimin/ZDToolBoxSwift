# ZDToolBoxSwift

A collection of Swift utilities and common UI/Foundation extensions.

## Installation

### CocoaPods

```ruby
pod 'ZDToolBoxSwift'
```

### Swift Package Manager

In `Xcode`, go to `File` -> `Add Package Dependencies...` and use:

```text
https://github.com/faimin/ZDToolBoxSwift.git
```

Then add the `ZDToolBoxSwift` product to your target.

## Component Overview

- `Source/Classes/Extension`: UIKit/Foundation extensions
- `Source/Classes/Tool`: Utility helpers (delayed execution, JSON, encryption/decryption, thread-safe wrappers, etc.)
- `Source/Classes/SubClass`: Reusable view subclasses
- `Source/Classes/PropertyWrapper`: Property wrappers

## Testing

Demo project tests are located at:

- `ZDToolBoxSwiftDemo/ZDToolBoxSwiftDemoTests`
- `ZDToolBoxSwiftDemo/ZDToolBoxSwiftDemoUITests`

Use the `Testing` framework (Swift Testing) by default.

## Recent Changes

See [CHANGELOG.md](CHANGELOG.md).
