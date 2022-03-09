#
# Be sure to run `pod lib lint HiClass_SDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HiClass_SDK'
  s.version          = '2.0.2.1'
  s.summary          = 'A short description of HiClass_SDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zhangkaixiang.ex/HiClass_SDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhangkaixiang.ex' => 'zhangkaixiang.ex@hx-partners.com' }
  s.source           = { :git => 'https://github.com/zhangkaixiang.ex/HiClass_SDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.static_framework = true

  # 源码类
  s.source_files = 'HiClass_SDK/Classes/**/*'
  # xib资源（放在bundle中引用无效，所以直接引入到Framework中）
  s.resource = 'HiClass_SDK/Resources/*'
  # 图片、国际化文件，打包到HiClass_SDK.bundle中
  s.resource_bundles = {
      'HiClass_SDK' => ['HiClass_SDK/Assets/*']
  }
  
  # PrefixHeader 内容
  s.prefix_header_contents = '#import "HiClass_SDKHeader.h"'
  s.public_header_files = 'Pod/Classes/HICSDKManage/HICSDKManage.h'
  s.vendored_frameworks = 'HiClass_SDK/USFrameworks/**/*.{framework}'
  s.vendored_libraries = 'HiClass_SDK/USFrameworks/**/*.{a}'

#    s.resource = 'HiClass_SDK/Assets/*'
#    s.resource = 'HiClass_SDK/HiClassBundle/*'
    
  s.frameworks = 'UIKit', 'MapKit', 'AVFoundation', 'AVKit'
  s.libraries = 'c++', 'opencore-amrnb', 'opencore-amrwb'
  
  
  s.dependency 'Masonry'
  s.dependency 'AFNetworking', '~> 4.0'
  s.dependency 'CocoaLumberjack'
  s.dependency 'Alamofire', '~> 4.7.3'
  s.dependency 'CryptoSwift'
  s.dependency 'HandyJSON'
  s.dependency 'SWXMLHash', '5.0.1' #该版本只能随着网络SDK变更，升级将不可用
  s.dependency 'SwiftyJSON'
  s.dependency 'SDWebImage'
  s.dependency 'MJExtension'
  s.dependency 'MJRefresh'
  s.dependency 'RealReachability'
  s.dependency 'GCDWebServer/WebDAV'
  s.dependency 'KissXML'
  s.dependency 'YYText'
  s.dependency 'Bugly'
  s.dependency 'SSZipArchive'
  s.dependency 'Cronet'
  # 高德地图
  s.dependency 'AMap3DMap'
  s.dependency 'AMapLocation'

end
