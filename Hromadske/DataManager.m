//
//  DataManager.m
//  Hromadske
//
//  Created by Admin on 20.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "DataManager.h"
#import <MagicalRecord.h>
#import "Employe.h"

@implementation DataManager


- (void)saveTeamToContext:(NSArray *)arrayOfTeam
{
    for (int i=0; i<[arrayOfTeam count]; i++)
    {
        Employe *employe = [Employe MR_createEntity];
        employe.name = [[arrayOfTeam objectAtIndex:i] valueForKey:@"title"];
        employe.image = [self downloadImage:[[arrayOfTeam objectAtIndex:i] valueForKey:@"image"] withName:i];
        [employe.managedObjectContext MR_saveToPersistentStoreAndWait];
    }
    
}

- (NSInteger) countEmployes
{
    return [Employe MR_countOfEntities];
}

-(NSArray *) fetchArrayOfEmployes
{
    return [Employe MR_findAll];
}

-(NSString *)downloadImage:(NSString *)url withName:(int)imageName
{
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    NSString *filePath = [NSString stringWithFormat:@"%d.jpeg",imageName];
    NSArray * ditPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [ditPath objectAtIndex:0];
    NSString *jpegFilePath = [docDir stringByAppendingPathComponent:filePath];
    NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.1f)];
    [data writeToFile:jpegFilePath atomically:YES];
    return jpegFilePath;
}

@end
