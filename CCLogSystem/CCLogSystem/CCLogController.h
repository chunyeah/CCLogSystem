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
#import "CCFileOutputRedirectionController.h"
#import "CCLogSystem.h"

@interface CCLogController : NSObject

@property (nonatomic, weak) id <CCFileOutputRedirectionController> fileOutputRedirectionController;

@property (nonatomic, copy, readonly) NSString *logsDirectory;

@property (nonatomic, copy, readonly) NSArray *availableLogs;

- (void)startCapturingLogsWithRedirectionController: (id <CCFileOutputRedirectionController>)fileOutputRedirectionController logType:(CCLogType)logType;

- (void)stopCapturingLogs;

- (void)removeOldLogsExceedingTotalSize: (unsigned long long)maximumTotalSize savingAtLeast: (NSUInteger)minimumCount;

@end