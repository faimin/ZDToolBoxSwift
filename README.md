# ZDToolBoxSwift

Swift 工具类及常用 UI/Foundation 扩展集合。

## 安装

### CocoaPods

```ruby
pod 'ZDToolBoxSwift'
```

### Swift Package Manager

`Xcode` -> `File` -> `Add Package Dependencies...`，输入仓库地址：

```text
https://github.com/faimin/ZDToolBoxSwift.git
```

然后在依赖选择中添加产品 `ZDToolBoxSwift`。

## 组件概览

- `Source/Classes/Extension`: UIKit/Foundation 扩展
- `Source/Classes/Tool`: 常用工具（延迟任务、JSON、加解密、线程安全封装等）
- `Source/Classes/SubClass`: 常用视图子类
- `Source/Classes/PropertyWrapper`: 属性包装器

## 测试

Demo 工程测试位于：

- `ZDToolBoxSwiftDemo/ZDToolBoxSwiftDemoTests`
- `ZDToolBoxSwiftDemo/ZDToolBoxSwiftDemoUITests`

优先使用 `Testing` 框架（Swift Testing）。

## 最近更新

详见 [CHANGELOG.md](CHANGELOG.md)。
