# Uncomment this line to define a global platform for your project
# platform :ios, '7.1'
use_frameworks!
platform :ios, '8.0'
link_with 'PopdeemSDK', 'PopdeemSDKTests', 'TabbedTest'

target 'PopdeemSDK' do
	pod 'STTwitter'
	pod 'FBSDKLoginKit'
	pod 'FBSDKCoreKit'
	pod 'FBSDKShareKit'
	pod 'Bolts'
	pod 'Shimmer'
	pod 'Bolts'
	pod 'JSONModel'
end

target 'PopdeemSDKCore' do

end

target 'PopdeemSample' do
	pod 'PopdeemSDK', :path => '../Popdeem-SDK-iOS'
	pod 'PopdeemSDK/UIKit', :path => '../Popdeem-SDK-iOS'
end

target 'NavigationSample' do
	pod 'PopdeemSDK', :path => '../Popdeem-SDK-iOS'
	pod 'PopdeemSDK/UIKit', :path => '../Popdeem-SDK-iOS'
	pod 'Fabric'
	pod 'Crashlytics'
end

target 'TabbedTest' do
	pod 'PopdeemSDK', :path => '../Popdeem-SDK-iOS'
	pod 'PopdeemSDK/UIKit', :path => '../Popdeem-SDK-iOS'
	pod 'Fabric'
	pod 'Crashlytics'
	pod 'Reveal-iOS-SDK', :configurations => ['Debug']
end

target 'SwiftSample' do
	pod 'PopdeemSDK', :path => '../Popdeem-SDK-iOS'
	pod 'PopdeemSDK/UIKit', :path => '../Popdeem-SDK-iOS'
	pod 'Reveal-iOS-SDK', :configurations => ['Debug']
end

target 'PopdeemSDKTests' do
	pod 'Expecta', '~> 1.0.0'
	pod 'Nocilla'
	pod 'OCMock'
	pod 'Shimmer'
end


