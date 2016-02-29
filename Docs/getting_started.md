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
