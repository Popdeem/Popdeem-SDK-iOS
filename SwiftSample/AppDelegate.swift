//
//  AppDelegate.swift
//  SwiftTest
//
//  Created by Niall Quinn on 29/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

import UIKit
import PopdeemSDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
		PopdeemSDK.withAPIKey("26eb2fcb-06e5-4976-bff4-88c30cc58f58")
		PopdeemSDK.enableSocialLoginWithNumberOfPrompts(3)
		PopdeemSDK.registerForPushNotificationsApplication(application)
		PopdeemSDK.setUpThemeFile("theme")
		return true
	}
	
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
		PopdeemSDK.handleRemoteNotification(userInfo)
	}
	
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		PopdeemSDK.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
	}
	
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		PopdeemSDK.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
	}
	
	func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
		let wasHandled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication:sourceApplication, annotation: annotation);
		
		if wasHandled {
			return true
		}
		
		if (PopdeemSDK.canOpenUrl(url, sourceApplication: sourceApplication!, annotation: annotation)) {
			return PopdeemSDK.application(application, openURL: url, sourceApplication:sourceApplication!, annotation: annotation)
		}
		
		return false
	}
	
	func applicationWillResignActive(application: UIApplication) {
	}
	
	func applicationDidEnterBackground(application: UIApplication) {
	}
	
	func applicationWillEnterForeground(application: UIApplication) {
		
	}
	
	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		FBSDKAppEvents.activateApp()
	}
	
	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	
}

