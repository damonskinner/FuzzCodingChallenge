//
//  DCSFuzzData.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzData.h"

@implementation DCSFuzzData


+(DCSFuzzData *) dataFromDictionary:(NSDictionary *) fuzzDictionary {
    DCSFuzzData *fuzzData = [[DCSFuzzData alloc] init];
    
    if (!fuzzDictionary[@"data"]) {
        fuzzData.data = @"Error: No Data";
    } else {
        fuzzData.data = fuzzDictionary[@"data"];
    }
    
    if (!fuzzDictionary[@"date"]) {
        fuzzData.date = @"Error: No Date";
    } else {
        fuzzData.date = fuzzDictionary[@"date"];
    }

    fuzzData.dataId = fuzzDictionary[@"id"];
    fuzzData.type = fuzzDictionary[@"type"];
    
    fuzzData.fuzzImage = [UIImage imageNamed:@"placeholder"];
    return fuzzData;
}

@end
