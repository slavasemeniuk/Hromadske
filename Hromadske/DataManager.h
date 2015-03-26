//
//  DataManager.h
//  Hromadske
//
//  Created by Admin on 20.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject


- (void)saveTeamToContext:(NSArray *)arrayOfTeam;

- (NSArray *) fetchArrayOfEmployes;

- (NSInteger) countEmployes;

@end
