# Changelog

## 2026-04-01

### Added

- Added `Swift Package Manager` support with `Package.swift`, so `ZDToolBoxSwift` can be integrated via SPM.
- Excluded the debug-only `ZDLayoutGuide` implementation from the SPM target because it depends on a private header/API coupling.

### Fixed

- Fixed incorrect `y` reading in `ZDSWrapper where T: ZDView` (`origin.x` was used before; now `origin.y` is used).
- Fixed key cleanup timing in `ZDDelay.throttle`, so callbacks with the same key can be triggered again after completion.
- Fixed `ZDCrypto.aesDecrypt(encodedText:key:aad:)` by decoding Base64 input before decryption.
- Fixed potential dangling-reference crash risk in `ZDSNotificationToken` by using `weak` for `NotificationCenter` (instead of `unowned`).

### Tests

- Added to `ZDDelayTests`:
  - `debounceOnlyExecutesLastCallback`
  - `throttleCanExecuteAgainAfterPreviousCallbackFinished`
  - `viewWrapperYReflectsFrameOriginY`
- Added to `NSObjectCombineTests`:
  - `testAesEncryptDecryptRoundTrip`

### Docs

- Added documentation comments for `ZDDelay` methods (including parameter and return value descriptions).
- Updated `README.md` with installation instructions, component overview, testing notes, and changelog entry point.
