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

#import "CCLogController.h"

@interface CCLogController (Utility)

- (NSString *)pathForbasename:(NSString *)basename;

+ (NSDateFormatter *)dateFormatter;

+ (NSString *)basenamePrefix;

+ (NSString *)pathExtension;

+ (BOOL)forceConsoleLog;

+ (NSString *)basenameForDate:(NSDate *)date;

+ (NSString *)basenameForBasename:(NSString *)origBasename date2:(NSDate *)date2 date2Type:(NSString *)date2Type;

@end
