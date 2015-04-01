//
//  HelpProject.h
//  Hromadske
//
//  Created by Admin on 01.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HelpProject : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * content;

@end
