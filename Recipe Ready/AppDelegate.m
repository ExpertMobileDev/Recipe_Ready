//
//  AppDelegate.m
//  Recipe Ready
//
//  Created by mac on 11/14/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif


@import Firebase;
@import FirebaseMessaging;
@import FirebaseInstanceID;


#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@implementation AppDelegate

NSString *const kGCMMessageIDKey = @"gcm.message_id";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
	if (![UD stringForKey:kStrCreatedRecipeOption])
		appdata.strCreateRecipeOption = @"Everyone";
	if (![UD stringForKey:kStrProfilePhotoOption])
		appdata.strProfilePhotoOption = @"Everyone";
	
	appdata.nMyRecipeShowMode = CREATED;

	[FBSDKLoginButton class];
	[FIRApp configure];

	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
		// iOS 7.1 or earlier. Disable the deprecation warnings.
		#pragma clang diagnostic push
		#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		UIRemoteNotificationType allNotificationTypes = (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | 	 UIRemoteNotificationTypeBadge);
		[application registerForRemoteNotificationTypes:allNotificationTypes];
		#pragma clang diagnostic pop
	} else {
		// iOS 8 or later
		// [START register_for_notifications]
		if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
			UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
			UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
			[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
	} else {
		// iOS 10 or later
		#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
		UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
		[[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
		  }];

		// For iOS 10 display notification (sent via APNS)
		[UNUserNotificationCenter currentNotificationCenter].delegate = self;
		// For iOS 10 data message (sent via FCM)
		[FIRMessaging messaging].remoteMessageDelegate = self;
		#endif
		}
		
		[[UIApplication sharedApplication] registerForRemoteNotifications];
		// [END register_for_notifications]
	}

	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
											 name:kFIRInstanceIDTokenRefreshNotification object:nil];
	
	return [[FBSDKApplicationDelegate sharedInstance] application:application
							 didFinishLaunchingWithOptions:launchOptions];
}

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Receive data message on iOS 10 devices while app is in the foreground.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
	// Print full message
	[remoteMessage appData];
}
#endif

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
	   willPresentNotification:(UNNotification *)notification
		 withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
	// Print message ID.
	NSDictionary *userInfo = notification.request.content.userInfo;
	if (userInfo[kGCMMessageIDKey]) {
		NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
	}
	
	// Print full message.
	NSLog(@"%@", userInfo);
	
	// Change this to your preferred presentation option
	completionHandler(UNNotificationPresentationOptionNone);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
		 withCompletionHandler:(void (^)())completionHandler {
	NSDictionary *userInfo = response.notification.request.content.userInfo;
	if (userInfo[kGCMMessageIDKey]) {
		NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
	}
	
	// Print full message.
	NSLog(@"%@", userInfo);
	
	completionHandler();
}
#endif
// [END ios_10_message_handling]

- (void)tokenRefreshNotification:(NSNotification *)notification {
	// Note that this callback will be fired everytime a new token is generated, including the first
	// time. So if you need to retrieve the token as soon as it is available this is where that
	// should be done.

	NSString *refreshedToken = [[FIRInstanceID instanceID] token];
	NSLog(@"InstanceID token: %@", refreshedToken);
	// Connect to FCM since connection may have failed when attempted before having a token.
	[self connectToFcm];
	// TODO: If necessary send token to application server.
}

- (void)connectToFcm {
	// Won't connect since there is no token
	if (![[FIRInstanceID instanceID] token]) {
		return;
	}
	// Disconnect previous FCM connection if it exists.
	//[[FIRMessaging messaging] disconnect];
	[[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
		if (error != nil) {
		  NSLog(@"Unable to connect to FCM. %@", error);
		} else {
		  NSLog(@"Connected to FCM.");
		}
	}];
}

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
// the InstanceID token.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	NSLog(@"APNs token retrieved: %@", deviceToken);
	// With swizzling disabled you must set the APNs token here.
	[[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"Unable to register for remote notifications: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	// If you are receiving a notification message while your app is in the background,
	// this callback will not be fired till the user taps on the notification launching the application.
	// TODO: Handle data of notification

	// Print message ID.
	if (userInfo[kGCMMessageIDKey]) {
		NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
	}

	// Print full message.
	NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
	fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	// If you are receiving a notification message while your app is in the background,
	// this callback will not be fired till the user taps on the notification launching the application.
	// TODO: Handle data of notification

	// Print message ID.
	if (userInfo[kGCMMessageIDKey]) {
		NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
	}

	// Print full message.
	NSLog(@"%@", userInfo);

	[[FIRMessaging messaging] appDidReceiveMessage:userInfo];
	completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	[[FIRMessaging messaging] disconnect];
	NSLog(@"Disconnected from FCM");
	
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	application.applicationIconBadgeNumber = 0;
	[FBSDKAppEvents activateApp];
	[self connectToFcm];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark - FB Login


// In order to process the response you get from interacting with the Facebook login process,
// you need to override application:openURL:sourceApplication:annotation:
- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
			options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
	
	return [[FBSDKApplicationDelegate sharedInstance] application:application
														  openURL:url
														  options:options];
}

//// Still need this for iOS8
//- (BOOL)application:(UIApplication *)application
//			openURL:(NSURL *)url
//  sourceApplication:(nullable NSString *)sourceApplication
//		 annotation:(nonnull id)annotation
//{
//	[[FBSDKApplicationDelegate sharedInstance] application:application
//												   openURL:url
//										 sourceApplication:sourceApplication
//												annotation:annotation];
//	return YES;
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url 
    sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

	BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
																  openURL:url
														sourceApplication:sourceApplication
															   annotation:annotation];
	// Add any custom logic here.
	return handled;
} 


@end
