//
//  DataManager.m
//  Hromadske
//
//  Created by Admin on 20.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "DataManager.h"
#import <CoreData+MagicalRecord.h>
#import "Employe.h"
#import "RemoteManager.h"

@implementation DataManager

+(DataManager *)sharedManager
{
    static DataManager *__manager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        __manager = [[DataManager alloc] init];
    });
    
    return __manager;
}

- (void)addTeamToLocalContext:(NSArray *)arrayOfTeam
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    for (int i=0; i<[arrayOfTeam count]; i++)
    {
        Employe *employe = [Employe MR_createInContext:localContext];
        employe.name = [[arrayOfTeam objectAtIndex:i] valueForKey:@"title"];
        employe.image = [self downloadImage:[[arrayOfTeam objectAtIndex:i] valueForKey:@"image"] withName:i];
    }
    
}

- (NSInteger) countemployes
{
    return [Employe MR_countOfEntities];
}

-(NSArray *) getTeam
{
    if ([self countemployes] == 0)
    {
        [RemoteManager parseTeam];
    }
    return [Employe MR_findAll];
}

-(NSString *)downloadImage:(NSString *)url withName:(int)imageName
{
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *jpegFilePath = [NSString stringWithFormat:@"%@/%d.jpeg", docDir, imageName];
    NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.5f)];
    [data writeToFile:jpegFilePath atomically:YES];
    return jpegFilePath;
}

@end
