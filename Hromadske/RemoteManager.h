//
//  RemoteManager.h
//  Hromadske
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteManager : NSObject


- (void) parsedTeam:(void (^)(id jsonResponse)) successCallback;

@end
