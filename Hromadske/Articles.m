//
//  Articles.m
//  Hromadske
//
//  Created by Admin on 13.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//


#import "Articles.h"
#import "Video.h"
#import "Photo.h"
#import "Link.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation Articles

@dynamic category;
@dynamic content;
@dynamic created_at;
@dynamic id;
@dynamic short_description;
@dynamic title;
@dynamic views_count;
@dynamic vk_id;
@dynamic withLink;
@dynamic withPhoto;
@dynamic withVideo;

-(void) convertDataToArticleModel: (NSArray *) article
{
    self.id = [article valueForKey:@"id"];
    self.short_description = [article valueForKey:@"short_description"];
    //self.created_at =[article valueForKey:@"created_at"];
    self.category = [article valueForKey:@"category"];
    self.title = [article valueForKey:@"title"];
    self.vk_id = [article valueForKey:@"vk_id"];
    self.content = [article valueForKey:@"content"];
    self.views_count = [article valueForKey:@"views_count"];
    
    NSArray *videos = [[article valueForKey:@"attachment"] valueForKey:@"videos" ];
    NSArray *links = [[article valueForKey:@"attachment"] valueForKey:@"links" ];
    NSArray *photos = [[article valueForKey:@"attachment"] valueForKey:@"photos" ];
    
    NSManagedObjectContext *context = nil;
    NSMutableSet *setOfVideos=[[NSMutableSet alloc] init];
    for (int i=0; i<[videos count]; i++)
    {
        Video *video = [Video MR_createEntity];
        video.url = [[videos objectAtIndex:i] valueForKey:@"videos"];
        [setOfVideos addObject:video];
    }
    
    NSMutableSet *setOfPhotos=[[NSMutableSet alloc] init];
    for (int i=0; i<[photos count]; i++)
    {
        Photo *photo = [Photo MR_createEntity];
        photo.url = [[photos objectAtIndex:i] valueForKey:@"scr"];
        [setOfPhotos addObject:photo ];
    }

    NSMutableSet *setOfLinks=[[NSMutableSet alloc] init];
    for (int i=0; i<[links count]; i++)
    {
        Link *link = [Link MR_createEntity];
        link.url = [[links objectAtIndex:i] valueForKey:@"url"];
        [setOfLinks addObject:link];
    }
    
    [context MR_saveToPersistentStoreAndWait];
    [self addWithPhoto:setOfPhotos];
    [self addWithVideo:setOfVideos];
    [self addWithLink:setOfLinks];
}


@end
