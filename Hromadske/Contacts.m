//
//  Contacts.m
//  Hromadske
//
//  Created by Admin on 01.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "Contacts.h"


@implementation Contacts

@dynamic emails;
@dynamic lat;
@dynamic lon;
@dynamic phones;
@dynamic place;
@dynamic url;

-(void)convertDataToContactsModel:(NSArray *)contacts
{
    self.emails = [contacts valueForKey:@"email"];
    self.lat = [contacts valueForKey:@"lat"];
    self.lon = [contacts valueForKey:@"lon"];
    self.phones = [contacts valueForKey:@"phone"];
    self.place = [contacts valueForKey:@"place"];
    self.url = [contacts valueForKey:@"url"];
}

@end
