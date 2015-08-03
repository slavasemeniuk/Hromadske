//
//  Categories.h
//  
//
//  Created by Device Ekreative on 03/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Articles;

@interface Categories : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *articles;
@end

@interface Categories (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(Articles *)value;
- (void)removeArticlesObject:(Articles *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

@end
