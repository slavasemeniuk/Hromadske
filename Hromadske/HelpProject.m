//
//  HelpProject.m
//  Hromadske
//
//  Created by Admin on 01.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "HelpProject.h"


@implementation HelpProject

@dynamic url;
@dynamic content;

-(void) convertDataToHelpProjectModel: (NSArray *) helpData
{
    self.content = [helpData valueForKey:@"content"];
    self.url = [helpData valueForKey:@"url"];
}

@end
