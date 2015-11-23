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
  s.version      = "0.1.18"
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


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "PopdeemSDK", "PopdeemSDK/**/*.{h,m}", "PopdeemSDK/**/**/*.{h,m}"
  s.public_header_files = "PopdeemSDK/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # s.resources = "Resources/*.png"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.frameworks = "CoreLocation", "UIKit"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true

  s.dependency "FBSDKLoginKit"
  s.dependency "FBSDKCoreKit"
  s.dependency "FBSDKShareKit"
  s.dependency "STTwitter"
  s.dependency "JSONModel"
end
