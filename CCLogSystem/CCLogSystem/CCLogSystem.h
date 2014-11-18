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

#import <Foundation/Foundation.h>
#import "CCLog.h"

// Support two types for logging, CCLog and NSLog.
// CCLog uses 'fprintf'
typedef NS_ENUM(NSInteger, CCLogType) {
    CCLogTypeCCLOG = 0,
    CCLogTypeNSLOG,
};

// Use this Macro to log
// Like: CC_LOG(@"This is a Log.");
// The default output is "Timestamp + Thread Info + FILE + LINE + FUNCTION + Log content", like: "2014-10-31 10:09:05.361 . <NSThread: 0x7ff6d3c24ae0>{number = 1, name = main} AppDelegate.m at 24 (-[AppDelegate log]): @"Thi is a Log"
#define CC_LOG(...) \
CCLog (CC_LOCATION(), __VA_ARGS__)

// Use this Macro to directly log any value
// Like CC_LOG_VALUE(self.window) or CC_LOG_VALUE(self.window.frame)
#define CC_LOG_VALUE(...) \
CC_LOG(@"%@", CC_STRING_FOR_LOG_VALUE(__VA_ARGS__))

@interface CCLogSystem : NSObject

// Set up default log configure, the default exceedint total log size is 10*1024*1024, ang logType is CCLogTypeCCLOG
// We should call this function at "- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions"
+ (void)setupDefaultLogConfigure;

// We need to set up the log environment when our app launch
// totalLogSize : exceeding total log size, If log size is more than toalLogSize, will do some clean.
// logType: Support CCLogTypeCCLOG and CCLogTypeNSLOG
+ (void)setupLogConfigureWithExceedingTotalLogSize:(unsigned long long)toalLogSize logType:(CCLogType)logType;

// Call this method, If we want to review the logs, and we can email the log in Developer UI.
+ (void)activeDeveloperUI;

// Return the available logs
// If must call after setup log environment
+ (NSArray *)availableLogs;

@end

