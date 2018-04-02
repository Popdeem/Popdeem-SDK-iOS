## Getting Started  

### Installing Dependencies  
We use ***cocoapods*** to deliver the Popdeem SDK. To include the SDK in your project, add the following lines to your ***Podfile***  

```
	pod 'PopdeemSDK'
	pod 'PopdeemSDK/UIKit'
```

The ***PopdeemSDK*** pod is our core SDK library, and the ***PopdeemSDK/UIKit*** contains our prebuilt UI flow to get you up and running in no time.  

### Initialise SDK  

Initializing the SDK is as simple as adding one line to your `application: didFinishLaunchingWithOptions:` method in `AppDelegate.m`:  

```
	[PopdeemSDK withAPIKey:@"YOUR_POPDEEM_API_KEY"];
```

### Broadcast Features

Still in your `AppDelegate.m` file, to use the Popdeem Push Notification and Broadcast features, you must include the following Delegate Methods:  

```
  - (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [PopdeemSDK application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
  }

  - (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [PopdeemSDK application:application didFailToRegisterForRemoteNotificationsWithError:error];
  }

  - (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([[userInfo objectForKey:@"sender"] isEqualToString:@"popdeem"]) {
      [PopdeemSDK handleRemoteNotification:userInfo];
      return;
    }   
  }
```

### Strings

You will also need to add the strings used in the PopdeemSDK to your project. Add the contents of our [Strings](https://gist.github.com/NQuinn27/d66bf7962ab837c1b1d7 "Strings") file to your localized strings file, (Localizable.strings)). See our [Strings](https://github.com/Popdeem/Popdeem-SDK-iOS/blob/master/Docs/strings.md "Strings") section for more info.  

Next, set up your [Facebook App](https://github.com/Popdeem/Popdeem-SDK-iOS/tree/master/Docs/facebook_app_setup.md "Facebook App")  

---
[Docs Home](https://github.com/Popdeem/Popdeem-SDK-iOS/tree/master/Docs/README.md "Docs Home")
