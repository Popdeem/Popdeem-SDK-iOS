#
#  Be sure to run `pod spec lint PopdeemSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "PopdeemSDK"
  s.version      = "0.1.17"
  s.summary      = "PopdeemSDK is used to interact with the Popdeem API on iOS."
  s.description  = "For detailed instructions, see http://www.popdeem.com/developer"
  s.homepage     = "https://github.com/Popdeem/Popdeem-SDK-iOS.git"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = { :type => "MIT", :file => "LICENCE.txt" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "Niall Quinn" => "niall@popdeem.com" }
  s.social_media_url   = "http://twitter.com/niall_quinn1"


  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "7.1"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/Popdeem/Popdeem-SDK-iOS.git", :tag => s.version.to_s }


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # s.resources = "Resources/*.png"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.frameworks = "CoreLocation", "UIKit"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true

  # ――― Specs ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.default_subspecs = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = "PopdeemSDK/PopdeemSDK.m", "PopdeemSDK/Core/*.{h,m}", "PopdeemSDK/Core/**/*.{h,m}", "PopdeemSDK/Core/**/**/*.{h,m}"
    core.public_header_files = "PopdeemSDK/**/*.h", "PopdeemSDK/*.h"
    core.dependency "FBSDKLoginKit"
    core.dependency "FBSDKCoreKit"
    core.dependency "FBSDKShareKit"
    core.dependency "STTwitter"
    core.dependency "JSONModel"
  end

  s.subspec 'UIKit' do |uikit|
    uikit.source_files = "PopdeemSDK", 'PopdeemSDK/UIKit/*.{h,m}', 'PopdeemSDK/UIKit/**/*.{h,m}'
    uikit.dependency "PopdeemSDK/Core"
  end

end
