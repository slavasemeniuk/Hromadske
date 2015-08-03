//
//  Articles.m
//
//
//  Created by Device Ekreative on 03/08/2015.
//
//

#import "Articles.h"
#import "Link.h"
#import "Photo.h"
#import "Video.h"
#import "Categories.h"
#import <MagicalRecord/MagicalRecord.h>
#import "DateFormatter.h"
#import "HTMLManager.h"

@implementation Articles

@dynamic content;
@dynamic created_at;
@dynamic id;
@dynamic short_description;
@dynamic title;
@dynamic viewed;
@dynamic views_count;
@dynamic vk_id;
@dynamic links;
@dynamic photos;
@dynamic videos;
@dynamic category;

- (void)createArticlesDataModel:(NSDictionary*)article
{
    self.id = [article valueForKey:@"id"];
    self.short_description = [[HTMLManager sharedManager] removeTagsFromString:[article valueForKey:@"short_description"]];
    self.title = [[HTMLManager sharedManager] removeTagsFromString:[article valueForKey:@"title"]];

    self.created_at = [[DateFormatter sharedManager] convertToDateFromTimeStamp:[article valueForKey:@"created_at"]];

    Categories* category = [Categories MR_findFirstByAttribute:@"name" withValue:[article valueForKey:@"category"]];
    if (!category) {
        Categories* newCategory = [Categories MR_createEntity];
        newCategory.name = [article valueForKey:@"category"];
    }
    else {
        [self setCategory:category];
    }
    self.vk_id = [article valueForKey:@"vk_id"];
    self.views_count = [article valueForKey:@"views_count"];
    self.viewed = [NSNumber numberWithBool:NO];

    NSArray* videos = [[article valueForKey:@"attachments"] valueForKey:@"videos"];
    NSArray* links = [[article valueForKey:@"attachments"] valueForKey:@"links"];
    NSArray* photos = [[article valueForKey:@"attachments"] valueForKey:@"photos"];

    for (int i = 0; i < [videos count]; i++) {
        Video* video = [Video MR_createEntity];
        video.url = [[videos objectAtIndex:i] valueForKey:@"url"];
        [video.managedObjectContext MR_saveOnlySelfAndWait];
        [self addVideosObject:video];
    }
    for (int i = 0; i < [links count]; i++) {
        Link* link = [Link MR_createEntity];
        link.url = [[links objectAtIndex:i] valueForKey:@"url"];
        [link.managedObjectContext MR_saveOnlySelfAndWait];
        [self addLinksObject:link];
    }
    for (int i = 0; i < [photos count]; i++) {
        Photo* photo = [Photo MR_createEntity];
        photo.url = [[photos objectAtIndex:i] valueForKey:@"src"];
        [photo.managedObjectContext MR_saveOnlySelfAndWait];
        [self addPhotosObject:photo];
    }
}

- (void)makeViewed
{
    self.viewed = [NSNumber numberWithBool:YES];
    [self.managedObjectContext MR_saveOnlySelfAndWait];
}

- (NSString*)getImageUrl
{
    NSArray* listOfImage = [self.photos allObjects];
    if ([listOfImage count]) {
        Photo* image = [listOfImage objectAtIndex:0];
        return image.url;
    }
    return nil;
}

- (NSString*)getLink
{
    NSArray* listOfLinks = [self.links allObjects];
    if ([listOfLinks count]) {
        Link* link = [listOfLinks objectAtIndex:0];
        return link.url;
    }
    return nil;
}
- (NSString*)getVideoURL
{
    NSArray* listOfVideos = [self.videos allObjects];
    if ([listOfVideos count]) {
        Link* link = [listOfVideos objectAtIndex:0];
        return link.url;
    }
    return nil;
}

@end
