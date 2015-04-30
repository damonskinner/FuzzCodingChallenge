//
//  DCSFuzzAPI.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzAPI.h"
#import "DCSConstants.h"
#import <AFNetworking.h>

@implementation DCSFuzzAPI

+(void)getFuzzDataWithCompletionBlock:(void (^)(NSArray *, BOOL))completionBlock
{
    NSString *urlString = FuzzURLString;
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *rawResults = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"%@",rawResults);
        completionBlock(rawResults, YES);
        

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
        NSArray *errorArray = @[error];
        completionBlock(errorArray, NO);
    }];
}

@end
