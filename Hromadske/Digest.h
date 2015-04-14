//
//  DIgest.h
//  Hromadske
//
//  Created by Admin on 07.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Digest : NSObject

+ (Digest *) sharedManager;

- (void) getDigest;

- (NSInteger)countNewArticles;

-(void)setToZeroNewArticles;

@end
