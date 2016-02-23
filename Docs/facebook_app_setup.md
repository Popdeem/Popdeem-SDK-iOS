# Facebook App Setup

---

You will need to set up a Facebook application at the Facebook Dev Centre. You can do so by following this [Tutorial](https://developers.facebook.com/docs/apps/register "Facebook Tutorial"). You will need some details from your project first:

* Your App Identifier - This is found in your XCode Project. It will look something like this: It will look something like this: com.yourcompany.popdeemApp

---

When you have created your Facebook Application, you will need to set up some custom Open Graph Objects in order to use Popdeem correctly. You will need two objects:

* Brand Location, which inherits from **Place** and has an attribute **Geopoints**  
* Photo, which inherits from **Photo**

You then need to create *two* Open Graph stories using these objects:

* **Check in** at **Brand Location**. This has action type **Check In**, object type **Brand Location** and uses the **Map** attachments, with **brand_location.geopoints** highlighted.
* **Share** a **Photo**. This has action type **Share**, and object type **Photo**.

---

When you have your Facebook app set up, make note of your Facebook App ID. Back in your *info.plist* file in your XCode Project, add the following key-value pairs:

    "FacebookAppId": YOUR_FACEBOOK_APP_ID
    "FacebookDisplayName" : YOUR_FACEBOOK_APP_DISPLAY_NAME

Then, you need to add an Array called "URL Types". Inside you put a Dictionary, with an Array for Key "URL Schemes". Inside the Array you need to add a string of "fb" followed by your Facebook App ID. The info.plist file should look like the image below:

![Alt text](/assets/facebook_keys_plist.png)

Since iOS9, you must also make some additional entries in your *info.plist* for Facebook to work correctly.
