//
//  Contacts.h
//  Hromadske
//
//  Created by Admin on 01.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contacts : NSManagedObject

@property (nonatomic, retain) NSString * emails;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSString * phones;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSString * url;

-(void) convertDataToContactsModel: (NSArray *) contacts;

@end
