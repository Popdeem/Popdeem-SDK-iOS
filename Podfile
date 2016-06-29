# Uncomment this line to define a global platform for your project
# platform :ios, '7.1'
use_frameworks!
platform :ios, '8.0'
link_with 'PopdeemSDK', 'PopdeemSDKTests', 'TabbedTest'

target 'PopdeemSDK' do
	pod 'FBSDKLoginKit'
	pod 'FBSDKCoreKit'
	pod 'FBSDKShareKit'
	pod 'STTwitter'
	pod 'Bolts'
end

target 'PopdeemSDKCore' do
	pod 'FBSDKLoginKit'
	pod 'FBSDKCoreKit'
	pod 'FBSDKShareKit'
	pod 'STTwitter'
	pod 'Bolts'
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
end

target 'PopdeemSDKTests' do
	pod 'FBSDKLoginKit'
	pod 'FBSDKCoreKit'
	pod 'FBSDKShareKit'
	pod 'STTwitter'
	pod 'Bolts'
	pod 'Expecta', '~> 1.0.0'
	pod 'Nocilla'
	pod 'OCMock'
end


