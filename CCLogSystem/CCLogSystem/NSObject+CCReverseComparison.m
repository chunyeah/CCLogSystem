/*
 *  CCLogSystem - A Log system for iOS.Support print, record and review logs:
 *
 *      https://github.com/yechunjun/CCLogSystem
 *
 *  This code is distributed under the terms and conditions of the MIT license.
 *
 *  Author:
 *      Chun Ye <chunforios@gmail.com>
 *
 */

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

