//
//  CCLogController+Utility.h
//  CCLogSystem
//
//  Created by Chun Ye on 10/30/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

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
