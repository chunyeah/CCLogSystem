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

#import "CCSimpleFileOutputRedirectionController.h"

@interface CCSimpleFileOutputRedirectionController ()

@property (nonatomic, strong) NSFileHandle *inputFileHandleDup;

@end

@implementation CCSimpleFileOutputRedirectionController
@synthesize inputFileHandle;
@synthesize outputFileHandle;

- (void)startRecordLog
{
    int inputFileDescriptionDup = dup(self.inputFileHandle.fileDescriptor);
    dup2(self.outputFileHandle.fileDescriptor, self.inputFileHandle.fileDescriptor);
    
    self.inputFileHandleDup = [[NSFileHandle alloc] initWithFileDescriptor:inputFileDescriptionDup];
}

- (void)stopRecordLog
{
    dup2(self.inputFileHandleDup.fileDescriptor, self.inputFileHandle.fileDescriptor);
    self.inputFileHandleDup = nil;
}

@end
