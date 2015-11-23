# Uncomment this line to define a global platform for your project
# platform :ios, '7.1'

platform :ios, '7.1'
link_with 'PopdeemSDK', 'PopdeemSDKTests'

target 'PopdeemSDK' do
    pod 'FBSDKCoreKit'
    pod 'FBSDKLoginKit'
    pod 'FBSDKShareKit'
    pod 'STTwitter'
    pod 'JSONModel'
end

target 'PopdeemSample' do
    pod 'PopdeemSDK', :path => '../Popdeem-SDK-iOS'
    pod 'PopdeemSDK/UIKit', :path => '../Popdeem-SDK-iOS'
end

target 'PopdeemSDKTests' do
    pod 'Expecta', '~> 1.0.0'
    pod 'Nocilla'
end


