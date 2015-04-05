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

-(void)convertDataToEmployeModel:(NSArray *)employe
{
    self.name = [employe valueForKey:@"title"];
    self.image = [employe valueForKey:@"image"];
    self.bio = [employe valueForKey:@"fulltext"];

}

@end
