//
//  AppDelegate.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "AppDelegate.h"
#import "DataManager.h"
#import <SWRevealViewController/SWRevealViewController.h>
#import "ControllersManager.h"
#import "Constants.h"
#import <GoogleMaps/GoogleMaps.h>


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:API_GOOGLE];
    [DataManager sharedManager];
    
    SWRevealViewController *mainReavealViewController = [[SWRevealViewController alloc] initWithRearViewController:[[ControllersManager sharedManager] createMenuViewController] frontViewController:[[ControllersManager sharedManager] newsNavigationController]];
    self.window.rootViewController=mainReavealViewController;
    
    return YES;
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




@end
