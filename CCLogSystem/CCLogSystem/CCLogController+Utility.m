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

#import "CCLogController+Utility.h"

@implementation CCLogController (Utility)

- (NSString *)pathForbasename:(NSString *)basename
{
    NSString *fileName = [basename stringByAppendingPathExtension:[CCLogController pathExtension]];
    return [self.logsDirectory stringByAppendingPathComponent:fileName];
}

+ (NSString *)basenameForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [CCLogController dateFormatter];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString *basenamePrefix = [CCLogController basenamePrefix];
    NSString *basename = [basenamePrefix stringByAppendingString:dateString];
    return basename;
}

+ (NSString *)basenameForBasename:(NSString *)origBasename date2:(NSDate *)date2 date2Type:(NSString *)date2Type
{
    NSDateFormatter *dateFormatter = [CCLogController dateFormatter];
    NSString *date2String = [dateFormatter stringFromDate:date2];
    NSString *separator = [CCLogController separator];
    NSString *basename = [@[origBasename, date2String, date2Type] componentsJoinedByString:separator];
    return basename;
}

+ (BOOL)forceConsoleLog
{
    return [[[NSProcessInfo processInfo].environment objectForKey:@"NSUnbufferedIO"] boolValue];
}

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.dateFormat = @"yyyy-MM-dd-HHmmss";
    return dateFormatter;
}

+ (NSString *)basenamePrefix
{
    NSString *processName = [NSProcessInfo processInfo].processName;
    NSString *basenamePrefix = [NSString stringWithFormat:@"%@_", processName];
    return basenamePrefix;
}

+ (NSString *)pathExtension
{
    return @"log";
}

+ (NSString *)separator;
{
    return @"_";
}

@end
