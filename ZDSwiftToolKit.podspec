#
#  Be sure to run `pod spec lint ZDSwiftToolKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "ZDSwiftToolKit"
  spec.version      = "0.0.1"
  spec.summary      = "Swift工具"
  spec.description  = <<-DESC
    Swift工具类以及一些代码技巧
                   DESC
  spec.homepage     = "https://github.com/faimin/ZDSwiftToolKit"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.author             = { "faimin" => "fuxianchao@gmail.com" }
  # Or just: spec.author    = "faimin"
  # spec.authors            = { "faimin" => "fuxianchao@gmail.com" }
  # spec.social_media_url   = "https://twitter.com/faimin"
  # spec.platform     = :ios
  spec.platform     = :ios, "9.0"
  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"
  spec.source       = { 
    :git => "https://github.com/faimin/ZDSwiftToolKit.git", 
    :tag => "#{spec.version}" 
  }

  spec.source_files  = "Source/Classes", "Source/Classes/**/*.{swift}"
  spec.exclude_files = "Classes/Exclude"
  # spec.public_header_files = "Classes/**/*.h"
  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"
  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"
  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"
  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"
  spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
