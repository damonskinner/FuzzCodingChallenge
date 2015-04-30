//
//  DCSFuzzDatastore.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzDatastore.h"
#import "DCSFuzzAPI.h"
#import "DCSFuzzData.h"

@implementation DCSFuzzDatastore

+ (instancetype)sharedDataStore {
    static DCSFuzzDatastore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[DCSFuzzDatastore alloc] init];
    });
    
    return _sharedDataStore;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _fuzzDataArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void) populateDatastoreWithCompletionBlock:(void (^)(void))completionBlock {
    
    [DCSFuzzAPI getFuzzDataWithCompletionBlock:^(NSArray *arrayOfDicts) {
        
        for (NSDictionary *eachDictionary in arrayOfDicts) {
            [self.fuzzDataArray addObject:[DCSFuzzData dataFromDictionary:eachDictionary]];
            
        }
        completionBlock();
    }];
    
}



@end
