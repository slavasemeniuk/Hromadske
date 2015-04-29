//
//  AppDelegate.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "AppDelegate.h"
#import "DataManager.h"
#import "Constants.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:API_GOOGLE];
    [self setUpStatusBar];
    [DataManager sharedManager];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[DataManager sharedManager] updateDigest];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)setUpStatusBar{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

@end
