//
//  Employe.m
//  Hromadske
//
//  Created by Admin on 26.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "Employe.h"


@implementation Employe

@dynamic name;
@dynamic image;
@dynamic bio;
@dynamic identifire;
@dynamic position;

-(void)convertDataToEmployeModel:(NSDictionary *)employe
{
    self.name = [employe valueForKey:@"name"];
    self.image = [employe valueForKey:@"photo"];
    self.bio = [employe valueForKey:@"bio"];
    self.position = [employe valueForKey:@"position"];
    self.identifire = [employe valueForKey:@"id"] ;

}

@end
