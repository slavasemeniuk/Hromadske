//
//  RestKitManager.h
//  Hromadske
//
//  Created by Sviatoslav Semeniuk on 22/12/2015.
//  Copyright © 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RestKitManager : NSObject

+ (RestKitManager*)sharedManager;
+ (NSManagedObjectContext*) managedObjectContext;

@end
