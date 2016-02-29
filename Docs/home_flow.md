#Social Home

---

All of Popdeem's core mobile features are contained in the `Home` flow. There are various scenarios in which you may launch the Home flow.

#### Navigation Controller

The most native way to present the Home flow is to push it into your existing navigation controller heirarchy. If you are already working inside a Navigation Controller, simply use this line in your View Controller to trigger the Home flow:

```
	[PopdeemSDK presentHomeFlowInNavigationController:self.navigationController];
```
	
#### Tab Bar

If you are setting the Popdeem Rewards Home as a view on your Nav Bar, there is a slightly different method. When you have chosen which Tab Bar Item will be your Popdeem Home, in interface builder, make the root View an instance of `PDHomeViewController`. This will result in your app launching with Popdeem preloaded in your tab bar.

---

To customize the look and feel of the Popdeem SDK, check out the [Theming](https://github.com/Popdeem/Popdeem-SDK-iOS/tree/master/Docs/theme.md "Theming") section.  

---
[Docs Home](https://github.com/Popdeem/Popdeem-SDK-iOS/tree/master/Docs/README.md "Docs Home")

---
![Popdeem Home](googledrive.com/Popdeem/0BybHx9-1eNB4NDgwUW9aZTJNVEE/popdeem_sdk_home.png)
