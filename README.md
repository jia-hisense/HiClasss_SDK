# HiClass_SDK

[![CI Status](https://img.shields.io/travis/zhangkaixiang.ex/HiClass_SDK.svg?style=flat)](https://travis-ci.org/zhangkaixiang.ex/HiClass_SDK)
[![Version](https://img.shields.io/cocoapods/v/HiClass_SDK.svg?style=flat)](https://cocoapods.org/pods/HiClass_SDK)
[![License](https://img.shields.io/cocoapods/l/HiClass_SDK.svg?style=flat)](https://cocoapods.org/pods/HiClass_SDK)
[![Platform](https://img.shields.io/cocoapods/p/HiClass_SDK.svg?style=flat)](https://cocoapods.org/pods/HiClass_SDK)

## Example

To run the HiClass project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

### Changed
1，Extension -> UIImage+HICExtension.m：使用runtime黑魔法全局替换imageNamed方法实现，已保证加载Bundle内图片；
2，HiClass_SDK -> HICHeader.h: 修改NSLocalizableString(key, comment)宏定义，改为加载Bundle内国际化字符串。
3，图片资源，包括EMVoiceConverter内的图片，已添加到Image.assets中

### TODO
1，新建Example项目进行集成测试，编写集成说明书；（难点：本地Framework不会被打包到HiClassSDK中，需要手动集成🤮🤮）
2，更新代码以及图片等文件为最新版本；
3，自定义Configuration类管理配置项中的域名、阿里Key等信息；（应设置默认值以供SDK调用）
4，改写HICSDKManager类，删除无用方法以及Block，使用代理进行回调；新增打开完整应用的方法（需要根据登录状态修改应用RootVC）
5, Pod lib lint检测。可以使用github建个私有库进行测试。


## Installation

HiClass_SDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HiClass_SDK'
```

## Author

zhangkaixiang.ex, zhangkaixiang.ex@hx-partners.com

## License

HiClass_SDK is available under the MIT license. See the LICENSE file for more info.
