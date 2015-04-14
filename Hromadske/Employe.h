//
//  Employe.h
//  Hromadske
//
//  Created by Admin on 26.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Employe : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSNumber * identifire;
@property (nonatomic, retain) NSString * position;

-(void) convertDataToEmployeModel: (NSArray *) employe;

@end
