//
//  DCSFuzzAPI.h
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCSFuzzAPI : NSObject

+(void)getFuzzDataWithCompletionBlock:(void (^)(NSArray *, BOOL))completionBlock;

@end
