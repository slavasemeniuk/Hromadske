//
//  HTMLManager.h
//  Hromadske
//
//  Created by Admin on 02.05.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLManager : NSObject

+ (HTMLManager *)sharedManager;
- (NSString *)removeTagsFromString: (NSString *) string;
@end
