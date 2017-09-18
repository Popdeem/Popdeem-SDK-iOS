//
//  AppDelegate.swift
//  SwiftTest
//
//  Created by Niall Quinn on 29/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
		PopdeemSDK.withAPIKey("26eb2fcb-06e5-4976-bff4-88c30cc58f58")
    PopdeemSDK.startupBrands()
		PopdeemSDK.enableSocialLogin(withNumberOfPrompts: 3)
		PopdeemSDK.register(forPushNotificationsApplication: application)
		PopdeemSDK.setUpThemeFile("theme")
		
		for fontFamily in UIFont.familyNames {
			let fontNames = UIFont.fontNames(forFamilyName: fontFamily)
			print("\(fontFamily): \(fontNames)")
		}
		
		return true
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
		PopdeemSDK.handleRemoteNotification(userInfo)
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		PopdeemSDK.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		PopdeemSDK.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
	}
	
	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		let wasHandled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication:sourceApplication, annotation: annotation);
		
		if wasHandled {
			return true
		}
		
		if (PopdeemSDK.canOpen(url, sourceApplication: sourceApplication!, annotation: annotation)) {
			return PopdeemSDK.application(application, open: url, sourceApplication:sourceApplication!, annotation: annotation)
		}
		
		return false
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		FBSDKAppEvents.activateApp()
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	
}

