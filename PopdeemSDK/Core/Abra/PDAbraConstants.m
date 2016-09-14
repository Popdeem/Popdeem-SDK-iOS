//
//  PDAbraConstants.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/09/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *const ABRA_URL = @"http://insights.popdeem.com";
NSString *const ABRA_EVENT_PATH = @"log_event";
NSString *const ABRA_TOKEN_PATH = @"fetch_token";

NSString *const ABRA_EVENT_VIEWED_LOGIN_TAKEOVER = @"Login Takeover Viewed";
NSString *const ABRA_EVENT_VIEWED_REWARDS_HOME = @"Rewards Home Viewed";
NSString *const ABRA_EVENT_VIEWED_ACTIVITY_FEED = @"Activity Feed Viewed";
NSString *const ABRA_EVENT_VIEWED_WALLET = @"Wallet Viewed";
NSString *const ABRA_EVENT_VIEWED_INSTA_TUTORIAL_MODULE_ONE = @"Instagram Tutorial Module One Viewed";
NSString *const ABRA_EVENT_VIEWED_INSTA_TUTORIAL_MODULE_TWO = @"Instagram Tutorial Module Two Viewed";
NSString *const ABRA_EVENT_VIEWED_CONNECT_INSTAGRAM = @"Connect Instagram Module Viewed";
NSString *const ABRA_EVENT_VIEWED_SETTINGS = @"Settings Viewed";
NSString *const ABRA_EVENT_VIEWED_INBOX = @"Settings Viewed";
NSString *const ABRA_EVENT_VIEWED_CLAIM = @"Claim Screen Viewed";

NSString *const ABRA_PROPERTYNAME_REWARD_TYPE = @"Reward Type";
NSString *const ABRA_PROPERTYVALUE_REWARD_TYPE_COUPON = @"Coupon";
NSString *const ABRA_PROPERTYVALUE_REWARD_TYPE_SWEEPSTAKE = @"Sweepstake";

NSString *const ABRA_PROPERTYNAME_REWARD_ACTION = @"Reward Action";
NSString *const ABRA_PROPERTYVALUE_REWARD_ACTION_CHECKIN = @"Check In";
NSString *const ABRA_PROPERTYVALUE_REWARD_ACTION_PHOTO = @"Photo";

NSString *const ABRA_PROPERTYNAME_NETWORKS_AVAILABLE = @"Networks Available";
NSString *const ABRA_PROPERTYVALUE_NETWORKS_AVAILABLE_FACEBOOK = @"Facebook";
NSString *const ABRA_PROPERTYVALUE_NETWORKS_AVAILABLE_TWITTER = @"Twitter";
NSString *const ABRA_PROPERTYVALUE_NETWORKS_AVAILABLE_INSTAGRAM = @"Instagram";

NSString *const ABRA_EVENT_CLICKED_CLOSE_LOGIN_TAKEOVER = @"Clicked Close Login Takeover";
NSString *const ABRA_EVENT_CLICKED_CLOSE_LOGIN_SIGNUP = @"Clicked Close Login Signup";
NSString *const ABRA_EVENT_CLICKED_CLOSE_INSTAGRAM_CONNECT = @"Clicked Close Instagram Connect Module";
NSString *const ABRA_EVENT_CLICKED_NEXT_INSTAGRAM_TUTORIAL = @"Clicked 'Next' on Instagram Connect";
NSString *const ABRA_EVENT_CLICKED_SIGN_IN_INSTAGRAM = @"Clicked Sign in To Instagram";

NSString *const ABRA_EVENT_CLAIMED = @"Claimed Reward";
NSString *const ABRA_PROPERTYNAME_SOCIAL_NETWORKS = @"Social Networks";
NSString *const ABRA_PROPERTYVALUE_SOCIAL_NETWORK_FACEBOOK = @"Facebook";
NSString *const ABRA_PROPERTYVALUE_SOCIAL_NETWORK_TWITTER = @"Twitter";
NSString *const ABRA_PROPERTYVALUE_SOCIAL_NETWORK_INSTAGRAM = @"Instagram";
NSString *const ABRA_PROPERTYNAME_PHOTO_ATTACHED = @"Photo"; // Boolean Values
NSString *const ABRA_PROPERTYNAME_REWARD_TYPE = @"Social Networks"; //ABRA_PROPERTYVALUE_REWARD_TYPE_COUPON etc

NSString *const ABRA_EVENT_CONNECTED_ACCOUNT = @"Connected Social Account";
NSString *const ABRA_PROPERTYNAME_SOCIAL_NETWORK = @"Social Network";
// Use value ABRA_PROPERTYVALUE_SOCIAL_NETWORK_FACEBOOK etc
NSString *const ABRA_PROPERTYNAME_SOURCE_PAGE = @"Source Page";
NSString *const ABRA_PROPERTYVALUE_SOURCE_PAGE_TAKEOVER = @"Login Takeover";
NSString *const ABRA_PROPERTYVALUE_SOURCE_PAGE_REWARD_LIST = @"Reward List";
NSString *const ABRA_PROPERTYVALUE_SOURCE_PAGE_SETTINGS = @"Settings";

NSString *const ABRA_PROPERTYNAME_PERMISSIONS = @"Permissions Granted";
NSString *const ABRA_PROPERTYVALUE_PERMISSIONS_EMAIL = @"Email";
NSString *const ABRA_PROPERTYVALUE_PERMISSIONS_EDUCATION = @"Education History";
NSString *const ABRA_PROPERTYVALUE_PERMISSIONS_PUBLIC_PROFILE = @"Public Profile";
NSString *const ABRA_PROPERTYVALUE_PERMISSIONS_USER_BIRTHDAY = @"User Birthday";
NSString *const ABRA_PROPERTYVALUE_PERMISSIONS_USER_FRIENDS = @"User Friends";
NSString *const ABRA_PROPERTYVALUE_PERMISSIONS_USER_POSTS = @"User Posts";
NSString *const ABRA_PROPERTYVALUE_PERMISSIONS_TAGGABLE_FRIENDS = @"User Posts";

NSString *const ABRA_EVENT_FACEBOOK_DENIED_PUBLISH_PERMISSIONS = @"Denied Publish Permissions";

NSString *const ABRA_EVENT_ADDED_CLAIM_CONTENT = @"Added Claim Content";
NSString *const ABRA_PROPERTYNAME_TEXT = @"Claim Text"; //Value is user text
NSString *const ABRA_PROPERTYNAME_PHOTO = @"Photo"; //Value null or Boolean?
NSString *const ABRA_PROPERTYNAME_TAGGED_FRIENDS = @"Tagged Friends"; //Value null or Boolean?

NSString *const ABRA_EVENT_RECEIVED_ERROR_ON_CLAIM = @"Error on Claim";
NSString *const ABRA_PROPERTYNAME_NO_HASHTAG = @"No Hashtag";
NSString *const ABRA_PROPERTYNAME_NO_NETWORK_SELECTED = @"No Network Selected";
NSString *const ABRA_PROPERTYNAME_NO_PHOTO = @"No Photo Added";

NSString *const ABRA_EVENT_TOGGLED_SOCIAL_BUTTON = @"Toggled Social Button";
NSString *const ABRA_PROPERTYNAME_SOCIAL_BUTTON_TYPE = @"Social Network";
// Use value ABRA_PROPERTYVALUE_SOCIAL_NETWORK_FACEBOOK etc
NSString *const ABRA_PROPERTYNAME_SOCIAL_BUTTON_STATE = @"Social Button State";
NSString *const ABRA_PROPERTYVALUE_SOCIAL_BUTTON_STATE_ON = @"On";
NSString *const ABRA_PROPERTYVALUE_SOCIAL_BUTTON_STATE_OFF = @"Off";

NSString *const ABRA_EVENT_REDEEMED_REWARD = @"Redeemed Reward";
NSString *const ABRA_PROPERTYNAME_REWARD_NAME = @"Reward Name";

NSString *const ABRA_EVENT_LOGIN = @"Login";
NSString *const ABRA_EVENT_LOGOUT = @"Logout";
NSString *const ABRA_EVENT_SIGNUP = @"Sign Up";

NSString *const ABRA_EVENT_DISCONNECT_SOCIAL_ACCOUNT = @"Disconnect Social Account";
//Use Social Networks above












