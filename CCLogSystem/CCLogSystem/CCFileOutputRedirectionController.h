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

@protocol CCFileOutputRedirectionController

@property (nonatomic, strong) NSFileHandle *inputFileHandle;
@property (nonatomic, strong) NSFileHandle *outputFileHandle;

- (void)startRecordLog;

- (void)stopRecordLog;

@end
