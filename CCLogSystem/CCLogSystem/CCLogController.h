//
//  CCLogController.h
//  CCLogSystem
//
//  Created by Chun Ye on 10/29/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

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