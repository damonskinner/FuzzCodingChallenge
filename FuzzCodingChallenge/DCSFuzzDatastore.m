//
//  DCSFuzzDatastore.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzDatastore.h"

@implementation DCSFuzzDatastore

+ (instancetype)sharedDataStore {
    static DCSFuzzDatastore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[DCSFuzzDatastore alloc] init];
    });
    
    return _sharedDataStore;
}





@end
