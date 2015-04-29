//
//  DCSFuzzDatastore.h
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCSFuzzDatastore : NSObject

@property (nonatomic, strong) NSMutableArray *fuzzDataArray;


+ (instancetype)sharedDataStore;

-(void) populateDatastoreWithCompletionBlock:(void (^)(void))completionBlock;

@end
