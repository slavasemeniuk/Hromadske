//
//  DataManager.h
//  Hromadske
//
//  Created by Admin on 20.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+(DataManager *)sharedManager;

- (void)addTeamToLocalContext:(NSArray *)arrayOfTeam;

- (NSArray *) getTeam;


@end
