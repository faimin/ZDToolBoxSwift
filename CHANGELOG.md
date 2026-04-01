# Changelog

## 2026-04-01

### Fixed

- 修复 `ZDSWrapper where T: ZDView` 的 `y` 读取错误（误读 `origin.x`，现为 `origin.y`）。
- 修复 `ZDDelay.throttle` 执行后未正确清理 key 的问题，确保同 key 任务可再次触发。
- 修复 `ZDCrypto.aesDecrypt(encodedText:key:aad:)` 未进行 Base64 解码导致的解密失败问题。
- 修复 `ZDSNotificationToken` 对 `NotificationCenter` 的 `unowned` 引用风险，改为 `weak`，避免悬垂引用崩溃。

### Tests

- 在 `ZDDelayTests` 新增：
  - `debounceOnlyExecutesLastCallback`
  - `throttleCanExecuteAgainAfterPreviousCallbackFinished`
  - `viewWrapperYReflectsFrameOriginY`
- 在 `NSObjectCombineTests` 新增：
  - `testAesEncryptDecryptRoundTrip`

### Docs

- 补充 `ZDDelay` 相关方法文档注释（参数与返回值说明）。
- 更新 `README.md`：新增安装、组件概览、测试说明与变更入口。
