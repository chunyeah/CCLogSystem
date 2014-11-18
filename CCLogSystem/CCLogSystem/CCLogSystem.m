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

#import "CCLogSystem.h"
#import "CCLogController.h"
#import "CCLogController+Utility.h"
#import "CCTeeController.h"
#import "CCSimpleFileOutputRedirectionController.h"
#import "CCLogViewController.h"
#import "CCLogController.h"

#define DEFAULT_EXCEEDING_TOTAL_LOG_SIZE   10*1024*1024

@interface CCLogSystem ()

@property (nonatomic, strong) CCLogController *logController;

@property (nonatomic, strong) NSObject <CCFileOutputRedirectionController> *redirectionController;

@end

@implementation CCLogSystem

+ (CCLogSystem *)defaultLogSystem
{
    static dispatch_once_t onceToken;
    static CCLogSystem *_defaultLogConfigure;
    dispatch_once(&onceToken, ^{
        _defaultLogConfigure = [[self alloc] init];
    });
    return _defaultLogConfigure;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.logController = [[CCLogController alloc] init];
    }
    return self;
}

+ (void)setupDefaultLogConfigure
{
    [self setupLogConfigureWithExceedingTotalLogSize:DEFAULT_EXCEEDING_TOTAL_LOG_SIZE logType:CCLogTypeCCLOG];
}

+ (void)setupLogConfigureWithExceedingTotalLogSize:(unsigned long long)toalLogSize logType:(CCLogType)logType
{
    CCLogSystem *logConfigure = [CCLogSystem defaultLogSystem];
    
    [logConfigure.logController removeOldLogsExceedingTotalSize:toalLogSize savingAtLeast:10];
    
    if (!logConfigure.redirectionController) {
        if ([CCLogController forceConsoleLog]) {
            logConfigure.redirectionController = [[CCTeeController alloc] init];
        } else {
            logConfigure.redirectionController = [[CCSimpleFileOutputRedirectionController alloc] init];
        }
        [logConfigure.logController startCapturingLogsWithRedirectionController:logConfigure.redirectionController logType:logType];
        [logConfigure.redirectionController startRecordLog];
    }
}

+ (void)activeDeveloperUI
{
    CCLogViewController *logViewController = [[CCLogViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:logViewController];
    
    UIApplication *application = [UIApplication sharedApplication];
    [application.windows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKeyWindow]) {
            UIWindow *keyWindow = obj;
            if (keyWindow.rootViewController) {
                [keyWindow.rootViewController presentViewController:navigationController animated:YES completion:NULL];
            }
        }
    }];
}

+ (NSArray *)availableLogs
{
    if ([CCLogSystem defaultLogSystem].logController) {
        return [CCLogSystem defaultLogSystem].logController.availableLogs;
    } else {
        return nil;
    }
}

@end
