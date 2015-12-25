//
//  RestKitManager.m
//  Hromadske
//
//  Created by Sviatoslav Semeniuk on 22/12/2015.
//  Copyright © 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "RestKitManager.h"
#import <RestKit/RestKit.h>
#import <CoreData/CoreData.h>
#import "Articles.h"
#import "Link.h"
#import "Photo.h"
#import "RateAndWeather.h"
#import "Video.h"
#import "Categories.h"
#import "Employe.h"
#import "Constants.h"

@interface RestKitManager()
@property NSManagedObjectContext* managedObjectContext;
@end

@implementation RestKitManager

+ (RestKitManager*)sharedManager
{
    static RestKitManager* __manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[RestKitManager alloc] init];
    });
    
    return __manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        RKManagedObjectStore* managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
        NSError *error;
        if (!RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error)) {
            NSLog(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
            abort();
        }
        
        NSURL* pathToPersistantStore = [[NSURL alloc] initWithString:RKApplicationDataDirectory()];
        pathToPersistantStore = [pathToPersistantStore URLByAppendingPathComponent:@"Hromadske 2.sqlite"];
        NSLog(@"%@", RKApplicationDataDirectory());
        
        NSPersistentStore* persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath: pathToPersistantStore.absoluteString  fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
        
        if (error) {
            persistentStore = nil;
        }
        
        if (persistentStore == nil) {
            NSLog(@"Failed adding persistent store at path '%@': %@", pathToPersistantStore, error);
            NSLog(@"Recreating store");
            NSError* fileManagerError;
            [[NSFileManager defaultManager] removeItemAtPath:pathToPersistantStore.absoluteString error:&error];
            if (fileManagerError) {
                NSLog(@"Failed to remove persistent store at path %@: %@", pathToPersistantStore.absoluteString, error);
                abort();
            }
            
            persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath: pathToPersistantStore.absoluteString fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
            if (error) {
                persistentStore = nil;
                NSLog(@"Really failed adding persistent store at path '%@': %@", pathToPersistantStore, error);
                abort();
            }          
                
        }
        
        [managedObjectStore createManagedObjectContexts];
        
        RKObjectManager* manager = [RKObjectManager managerWithBaseURL:[[NSURL alloc] initWithString:base_URL]];
        manager.requestSerializationMIMEType = RKMIMETypeJSON;
        manager.managedObjectStore = managedObjectStore;
        
        RKEntityMapping* linkMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Link class]) inManagedObjectStore:managedObjectStore];
        [linkMapping addAttributeMappingsFromArray:[Link mappingArray]];
        RKEntityMapping* videoMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Video class]) inManagedObjectStore:managedObjectStore];
        [videoMapping addAttributeMappingsFromDictionary:[Photo mappingDictionary]];
        RKEntityMapping* photoMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Photo class]) inManagedObjectStore:managedObjectStore];
        [photoMapping addAttributeMappingsFromDictionary:[Photo mappingDictionary]];
        RKEntityMapping* categoryMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Categories class]) inManagedObjectStore:managedObjectStore];
        [categoryMapping addAttributeMappingsFromDictionary:[Categories mappingDict]];
        [categoryMapping setIdentificationAttributes:[Categories identificationAttributes]];
        
        
        RKEntityMapping* articlesMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Articles class]) inManagedObjectStore:managedObjectStore];
        [articlesMapping addAttributeMappingsFromArray:[Articles mappingArray]];
        [articlesMapping setIdentificationAttributes:[Articles identificationAttributes]];
        
        [articlesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"attachments.links" toKeyPath:@"links" withMapping:linkMapping]];
        [articlesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"attachments.photos" toKeyPath:@"photos" withMapping: photoMapping]];
        [articlesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"attachments.videos" toKeyPath:@"videos" withMapping: videoMapping]];
        [articlesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"category" withMapping: categoryMapping]];
        
        RKEntityMapping* employeeMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Employe class]) inManagedObjectStore:managedObjectStore];
        [employeeMapping addAttributeMappingsFromArray:[Employe mappingArray]];
        [employeeMapping addAttributeMappingsFromDictionary:[Employe mappingDict]];
        [employeeMapping setIdentificationAttributes:[Employe identificationAttributes]];
        
        RKEntityMapping* rateAndWeatherMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([RateAndWeather class]) inManagedObjectStore:managedObjectStore];
        [rateAndWeatherMapping addAttributeMappingsFromDictionary:[RateAndWeather mappingDictionary]];
        
        RKResponseDescriptor* employeResponceDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:employeeMapping method:RKRequestMethodGET pathPattern:TEAM_JSON keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [manager addResponseDescriptor:employeResponceDescriptor];
        
        RKResponseDescriptor* articleResponceDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:articlesMapping method:RKRequestMethodGET pathPattern:ARTICKE_JSON keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [manager addResponseDescriptor:articleResponceDescriptor];
        
        RKResponseDescriptor* digestResponceDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:rateAndWeatherMapping method:RKRequestMethodGET pathPattern:DIGEST_JSON keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [manager addResponseDescriptor:digestResponceDescriptor];
        [manager addFetchRequestBlock:^NSFetchRequest *(NSURL *URL) {
            RKPathMatcher* pathMatcher = [RKPathMatcher pathMatcherWithPattern:DIGEST_JSON];
            if ([pathMatcher matchesPath:URL.relativePath tokenizeQueryStrings:NO parsedArguments:nil]) {
                return [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([RateAndWeather class])];
            }
            return nil;
        }];
        
        
        
        
    }
    return self;
}

+ (NSManagedObjectContext*) managedObkjectContext {
    return [[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext];
}

@end
