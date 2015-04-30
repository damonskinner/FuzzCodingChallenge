//
//  DCSFuzzData.h
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DCSFuzzData : NSObject

@property (nonatomic, strong) NSString *data;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *dataId;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) UIImage *fuzzImage;

+(DCSFuzzData *) dataFromDictionary:(NSDictionary *) fuzzDictionary;

@end
