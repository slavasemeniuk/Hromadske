//
//  Articles.m
//  Hromadske
//
//  Created by Admin on 05.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "Articles.h"


@implementation Articles

@dynamic id;
@dynamic short_description;
@dynamic created_at;
@dynamic category;
@dynamic title;
@dynamic vk_id;
@dynamic content;
@dynamic views_count;

-(void) convertDataToArticleModel: (NSArray *) article
{
    self.id = [article valueForKey:@"id"];
    self.short_description = [article valueForKey:@"short_description"];
    self.created_at= [article valueForKey:@"created_at"];
    self.category = [article valueForKey:@"category"];
    self.title = [article valueForKey:@"title"];
    self.vk_id = [article valueForKey:@"vk_id"];
    self.content = [article valueForKey:@"content"];
    self.views_count = [article valueForKey:@"views_count"];
}

@end
