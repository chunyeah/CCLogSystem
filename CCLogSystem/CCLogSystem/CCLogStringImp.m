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

#import "CCLogStringImp.h"
#import "CCLocationMake.h"

#pragma mark - Private

static NSDateFormatter *regeneratedLogDateFormatter (void)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    return dateFormatter;
}

static NSObject *CCNullForZeroLengthString (NSString *string)
{
    return [string length] ? string : [NSNull null];
}

static NSString *stringWithLogInfo (CCLocation location, NSString *logInfo)
{
    NSString *body = [[NSArray arrayWithObjects:@".", CCNullForZeroLengthString(CCLogPrefixFromLocation(location)), logInfo, nil] componentsJoinedByString:@" "];
    
    NSString *timestamp = [regeneratedLogDateFormatter() stringFromDate:[NSDate date]];
    
    NSString *string = [NSString stringWithFormat:@"%@ %@", timestamp, body];
    
    return string;
}

#pragma mark - Public

void CCLogStringToNSLog (CCLocation location, NSString *string)
{
    NSString *logString = stringWithLogInfo(location, string);
    NSLog(@"%@", logString);
}

void CCLogStringToStderr (CCLocation location, NSString *string)
{
    NSString *logString = stringWithLogInfo(location, string);
    fprintf (stderr, "%s\n", [logString UTF8String]);
}