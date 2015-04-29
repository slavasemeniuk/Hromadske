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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIView *addStatusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, 20)];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        addStatusBar.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:123.0f/255.0f blue:40.0f/255.0f alpha:1];
        [self.window.rootViewController.view addSubview:addStatusBar];
    }

}

@end
