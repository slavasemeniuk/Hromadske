//
//  Entity.h
//  Hromadske
//
//  Created by Admin on 26.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) UNKNOWN_TYPE image;

@end
