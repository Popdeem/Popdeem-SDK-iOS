#Customize the PopdeemSDK Theme

---


To integrate our interface more seamlessly into your iOS application, you can make use of our theming system. To implement your own theme, copy the *theme.json* file from this [link](https://gist.github.com/NQuinn27/df08250c6a9c7464b4e4 "Popdeem Theme"), and change the colours to suit. When you are done, include this theme file in your project, and add the following to your `application: didFinishLaunchingWithOptions:` method in `AppDelegate.m`:

	[PopdeemSDK setUpThemeFile:@"theme"];

where *theme* is the name of the theme file included in your application bundle.

---

Next, you may want to customize the [Strings](https://github.com/Popdeem/Popdeem-SDK-iOS/tree/master/Docs/strings.md "Strings") throughout the PopdeemSDK

---

[Docs Home](https://github.com/Popdeem/Popdeem-SDK-iOS/tree/master/Docs/README.md "Docs Home")
