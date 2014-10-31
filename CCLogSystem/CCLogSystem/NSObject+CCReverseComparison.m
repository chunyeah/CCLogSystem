//
//  NSString+CCReverseComparison.m
//  CCLogSystem
//
//  Created by Chun Ye on 10/29/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import "NSObject+CCReverseComparison.h"
#import "CCLogSystem.h"

@interface NSObject (CCComparison)

- (NSComparisonResult)compare:(id)object;

@end

@implementation NSObject (CCReverseComparison)

- (NSComparisonResult)reverseCompare:(id)object
{
    NSComparisonResult directComparisonResult = NSOrderedSame;
    if ([self respondsToSelector:@selector(compare:)]) {
        directComparisonResult = [self compare: object];
        NSComparisonResult comparisonResult = (NSOrderedAscending == directComparisonResult)
        ? (NSComparisonResult) NSOrderedDescending
        : ((NSOrderedDescending == directComparisonResult)
           ? (NSComparisonResult) NSOrderedAscending
           : directComparisonResult);
        
        return comparisonResult;
    } else {
        CC_LOG(@"!!! %@ -> This object didn't implement \"comare\" function.", self);
        return directComparisonResult;
    }
}

@end

