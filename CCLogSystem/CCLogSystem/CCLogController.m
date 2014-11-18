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
#import "CCLogController+Utility.h"
#import <UIKit/UIKit.h>

#import <signal.h>
#import <unistd.h>
#import <asl.h>

#import "CCLog.h"
#import "NSObject+CCReverseComparison.h"

static NSPointerArray *_logContollerContainer;

@interface CCLogController ()

@property (nonatomic, copy) NSString *logsDirectory;

@property (nonatomic, copy) NSArray *availableLogs;

@property (nonatomic, copy) NSString *outputBasename;

// Crash
@property (nonatomic) int stdOutDup;

@property (nonatomic) BOOL stdOutToStdErrRedirectEnabledImp;

@end

@implementation CCLogController

#pragma mark - Init

+ (void)load
{
    _logContollerContainer = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsWeakMemory];
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *fullNamespace = @"tips.chun.CCLogSystem";
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        self.logsDirectory = [paths[0] stringByAppendingPathComponent:fullNamespace];
    }
    
    [_logContollerContainer addPointer:(__bridge void *)(self)];
    
    return self;
}

#pragma mark - Set && Get

- (NSArray *)availableLogs
{
    NSArray *availableLogs;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:self.logsDirectory error:&error];
    if (!contents) {
        availableLogs = nil;
    } else {
        NSString *dotAndPathExtension = [[@"a" stringByAppendingString:[CCLogController pathExtension]] substringFromIndex:1];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(self endswith %@) and (self beginswith %@)", dotAndPathExtension, [CCLogController basenamePrefix]];
        NSArray *filteredContents = [contents filteredArrayUsingPredicate:predicate];
        NSMutableArray *filteredPaths = [NSMutableArray array];
        
        for (NSString *filename in filteredContents) {
            NSString *path = [self.logsDirectory stringByAppendingPathComponent:filename];
            [filteredPaths addObject:path];
        }
        
        availableLogs = [filteredPaths sortedArrayUsingSelector:@selector(reverseCompare:)];
    }
    
    return availableLogs;
}

#pragma mark - Public

- (void)startCapturingLogsWithRedirectionController: (id <CCFileOutputRedirectionController>)fileOutputRedirectionController logType:(CCLogType)logType
{
    if (logType == CCLogTypeCCLOG) {
        switchToCCLog();
    } else {
        switchToNSLog();
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *outputBasename = [CCLogController basenameForDate:[NSDate date]];
    NSString *outputFilePath = [self pathForbasename:outputBasename];
    
    if (![fileManager fileExistsAtPath:self.logsDirectory]) {
        NSError *error;
        [fileManager createDirectoryAtPath:self.logsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    BOOL fileAlreadyExists = [fileManager fileExistsAtPath:outputFilePath];
    
    if (!fileAlreadyExists) {
        NSData *data = [NSData data];
        [fileManager createFileAtPath:outputFilePath contents:data attributes:nil];
    }
    
    CC_LOG_VALUE(outputFilePath);
    
    NSFileHandle *outputFileHandle = [NSFileHandle fileHandleForWritingAtPath:outputFilePath];
    [outputFileHandle seekToEndOfFile];
    
    NSFileHandle *inputFileHandle = [NSFileHandle fileHandleWithStandardError];
    
    fileOutputRedirectionController.outputFileHandle = outputFileHandle;
    fileOutputRedirectionController.inputFileHandle = inputFileHandle;
    self.fileOutputRedirectionController = fileOutputRedirectionController;

    self.outputBasename = [[outputFilePath lastPathComponent] stringByDeletingPathExtension];
    
    [self startCapturingCrashLog];
}

- (void)stopCapturingLogs
{
    [self flush];
    self.fileOutputRedirectionController = nil;
}

- (void)removeOldLogsExceedingTotalSize: (unsigned long long)maximumTotalSize savingAtLeast: (NSUInteger)minimumCount
{
    NSArray *availableLogs = [self availableLogs];
    
    if (availableLogs && availableLogs.count > 0) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        unsigned long long totalSize = 0ULL;
        
        NSUInteger index;
        
        for (index = 0; index < availableLogs.count; index ++) {
            NSString *path = [availableLogs objectAtIndex:index];
            NSError *error;
            NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:&error];
            if (attributes) {
                unsigned long long fileSize = [[attributes valueForKey:@"NSFileSize"] longLongValue];
                unsigned long long updatedTotalSize = fileSize + totalSize;
                if (updatedTotalSize > maximumTotalSize) {
                    if (index < minimumCount) {
                        index = MIN(minimumCount, availableLogs.count);
                    }
                    break;
                } else {
                    totalSize = updatedTotalSize;
                }
            }
        }
        
        NSArray *logsForRemoval = [availableLogs subarrayWithRange:NSMakeRange(index, availableLogs.count - index)];
        
        for (NSString *pathForRemoval in logsForRemoval) {
            NSError *error;
            [fileManager removeItemAtPath:pathForRemoval error:&error];
        }
    }
}

#pragma mark - Private && Log

- (void)flush
{
    fflush (stderr);
    fflush (stdout);
    
    [self.fileOutputRedirectionController stopRecordLog];
}

- (void)relocateLogToType:(NSString *)type
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *basename = [CCLogController basenameForBasename:self.outputBasename date2:[NSDate date] date2Type:type];
    NSString *outputFilePath = [self pathForbasename:self.outputBasename];
    NSString *updatedPath = [self pathForbasename:basename];
    
    [fileManager linkItemAtPath:outputFilePath toPath:updatedPath error:NULL];
    
    [fileManager removeItemAtPath:outputFilePath error:NULL];
    
    self.outputBasename = basename;
}

#pragma mark - Private && Crash

static NSUncaughtExceptionHandler *originUncaughtExceptionHandler;

- (void)formulateCrashLog
{
    [self relocateLogToType:@"crashed"];
    
    [self setStdOutToStdErrRedirectEnabled:NO];
    
    [self stopCapturingLogs];
    
    asl_add_log_file (NULL, STDERR_FILENO);
}

static void logAwareUncaughtExceptionHandler (NSException *exception)
{
    CC_LOG_VALUE(exception.name);
    CC_LOG_VALUE(exception);
    CC_LOG_VALUE(exception.userInfo);
    CC_LOG_VALUE(exception.callStackSymbols);
    
    if (originUncaughtExceptionHandler) {
        originUncaughtExceptionHandler(exception);
    }
    
    [_logContollerContainer.allObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj formulateCrashLog];
    }];
}

- (void)startCapturingCrashLog
{
    [self setStdOutToStdErrRedirectEnabled:YES];
    
    originUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    
    NSSetUncaughtExceptionHandler(logAwareUncaughtExceptionHandler);
}

- (void)stopCapturingCrashLog
{
    NSSetUncaughtExceptionHandler (originUncaughtExceptionHandler);
    
    [self setStdOutToStdErrRedirectEnabled:NO];
    
    [self stopCapturingLogs];
}

- (void)setStdOutToStdErrRedirectEnabled:(BOOL)redirectEnabled
{
    if (redirectEnabled) {
        int stdOutDup = dup(STDOUT_FILENO);
        dup2(STDERR_FILENO, STDOUT_FILENO);
        self.stdOutDup = stdOutDup;
    } else {
        dup2(self.stdOutDup, STDOUT_FILENO);
        close(self.stdOutDup);
    }
    
    self.stdOutToStdErrRedirectEnabledImp = redirectEnabled;
}

- (BOOL)stdOutToStdErrRedirectEnabled
{
    return self.stdOutToStdErrRedirectEnabledImp;
}

@end
