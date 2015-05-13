//
//  AppDelegate.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkTracker.h"
#import "DataManager.h"
#import "ControllersManager.h"
#import "Constants.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>
#import <iRate/iRate.h>
#import "GAI.h"

@implementation AppDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpIRate];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NetworkTracker sharedManager];
    
    [GMSServices provideAPIKey:API_GOOGLE];
    [self setupGoogleAnalytics];
    
    [DataManager sharedManager];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.window.rootViewController= [[ControllersManager sharedManager] revealController];
    
    [self setUpParse:application launchOptions:launchOptions];
    
    return YES;
}

- (void) setupGoogleAnalytics {
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-46233904-2"];
}

- (void)setUpParse: (UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"fqJtrcykzHoLoJP0HArgmXrHpNoP9CJ0C7sPhp25"
                  clientKey:@"F6RDBlPldWL2iwxtDRp66KZwfdVj0XQoX2JYRemv"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    

}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[DataManager sharedManager] fetchRemoteDigest]; 
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (application.applicationState == UIApplicationStateInactive) {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    } else {
        [PFPush handlePush:userInfo];
    }
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (void) setUpIRate{
    [iRate sharedInstance].appStoreID = 987421683;
    [iRate sharedInstance].applicationBundleID = @"com.timothykozak.hromadske";
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    [iRate sharedInstance].previewMode = NO;
    [iRate sharedInstance].daysUntilPrompt=2;
    [iRate sharedInstance].usesUntilPrompt=5;
    [iRate sharedInstance].remindPeriod=5;
    [iRate sharedInstance].messageTitle=@"Оціни Громадське";
    [iRate sharedInstance].message=@"Якщо тобі сподобався додаток, оціни Громадське в AppStore";
    [iRate sharedInstance].CancelButtonLabel = @"Ні, дякую";
    [iRate sharedInstance].RemindButtonLabel = @"Нагадати пізніше";
    [iRate sharedInstance].RateButtonLabel = @"Оцінити";
}

@end
