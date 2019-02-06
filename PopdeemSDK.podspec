Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "PopdeemSDK"
  s.version      = "1.1.50"
  s.summary      = "PopdeemSDK is used to interact with the Popdeem Product on iOS."
  s.description  = "For detailed instructions, see http://www.popdeem.com/developer"
  s.homepage     = "https://github.com/Popdeem/Popdeem-SDK-iOS.git"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = { :type => "MIT", :file => "LICENCE.txt" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.authors            = { "Niall Quinn" => "niall@popdeem.com", "Daniel Farrell" => "danfar93@gmail.com" }
  s.social_media_url   = "http://twitter.com/niall_quinn1"


  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
	s.source       = { :git => "https://github.com/Popdeem/Popdeem-SDK-iOS.git", :tag => s.version.to_s }


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.resources = "PopdeemSDK/UIKit/*{xib,png,json}", "PopdeemSDK/UIKit/**/*.{xib,png,json}", "PopdeemSDK/UIKit/**/**/*.{xib,png,json}"
	
#	s.resource_bundles = {
#		"Resources" => ["PopdeemSDK/UIKit/Resources/*.png", "PopdeemSDK/UIKit/Resources/*.json", "PopdeemSDK/UIKit/*{xib,png}", "PopdeemSDK/UIKit/**/*.{xib,png}", "PopdeemSDK/UIKit/**/**/*.{xib,png}"]
#	}


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.frameworks = "CoreLocation", "UIKit", "Security", "SystemConfiguration"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true

  # ――― Specs ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.default_subspecs = 'Core'

	s.subspec 'Core' do |core|
    core.source_files = "PopdeemSDK/*.m", "PopdeemSDK/*.h", "PopdeemSDK/Core/*.{h,m}","PopdeemSDK/**/*.{h,m}" , "PopdeemSDK/Core/**/*.{h,m}", "PopdeemSDK/Core/**/**/*.{h,m}", "PopdeemSDK/UIKit/Common/Theme/PDTheme.{h,m}"
    core.public_header_files = "PopdeemSDK/**/*.h", "PopdeemSDK/*.h"
		core.dependency "FBSDKLoginKit"
		core.dependency "FBSDKCoreKit"
    core.dependency "FBSDKShareKit"
		core.dependency "Bolts"
		core.dependency "Shimmer"
		core.dependency "JSONModel"
    core.dependency "TOCropViewController"
    core.dependency "Realm"
    core.dependency "TwitterKit"
  end

  s.subspec 'UIKit' do |uikit|
    uikit.source_files = "PopdeemSDK", 'PopdeemSDK/UIKit/*.{h,m}', 'PopdeemSDK/UIKit/**/*.{h,m}', 'PopdeemSDK/UIKit/**/**/*.{h,m}'
    uikit.dependency "PopdeemSDK/Core"
  end

end
