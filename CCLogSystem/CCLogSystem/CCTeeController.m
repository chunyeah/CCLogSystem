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

#import "CCTeeController.h"
#import <unistd.h>
#import <stdio.h>
#import <errno.h>
#import <sys/types.h>
#import <sys/event.h>
#import <sys/time.h>
#import "CCLogSystem.h"

@interface CCTeeController ()

@property (nonatomic, strong) NSPipe *dataPipe;

@property (nonatomic, strong) NSPipe *pipeForSignallingEOF;

@property (nonatomic, strong) NSOperation *operation;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) NSFileHandle *inputFileHandleDup;

@property (nonatomic) BOOL closingInputFileHandleDup;

@end

@implementation CCTeeController
@synthesize inputFileHandle;
@synthesize outputFileHandle;

- (void)startRecordLog
{
    NSPipe *pipe = [NSPipe pipe];
    
    int inputFileDescriptionDup = dup(self.inputFileHandle.fileDescriptor);
    dup2(pipe.fileHandleForWriting.fileDescriptor, self.inputFileHandle.fileDescriptor);
    
    self.dataPipe = pipe;
    
    self.inputFileHandleDup = [[NSFileHandle alloc] initWithFileDescriptor:inputFileDescriptionDup];
    
    self.pipeForSignallingEOF = [NSPipe pipe];
    
    self.operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(thread:) object:nil];
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self.operationQueue addOperation:self.operation];
}

- (void)stopRecordLog
{
    self.closingInputFileHandleDup = YES;
    
    [self.pipeForSignallingEOF.fileHandleForWriting writeData:[@"<EOF>" dataUsingEncoding: NSUTF8StringEncoding]];
    
    [self.operationQueue waitUntilAllOperationsAreFinished];
    
    [self.dataPipe.fileHandleForWriting closeFile];
    
    dup2(self.inputFileHandleDup.fileDescriptor, self.inputFileHandle.fileDescriptor);
    
    self.closingInputFileHandleDup = NO;
    
    self.inputFileHandleDup = nil;
    
    self.dataPipe = nil;
    self.pipeForSignallingEOF = nil;
}

#pragma mark -
#pragma mark - Thread

- (void)thread:(NSDictionary *)arg
{
    @autoreleasepool {
        BOOL shouldTerminate = NO;
        
        NSFileHandle *fileHandleForReading = self.dataPipe.fileHandleForReading;
        NSFileHandle *fileHandleForSignallingEOF = self.pipeForSignallingEOF.fileHandleForReading;
        
        int kq = kqueue();
        
        NSFileHandle *kqueueFileHandle = [[NSFileHandle alloc] initWithFileDescriptor:kq closeOnDealloc:YES];
        
        struct kevent changes[2];
        EV_SET (&changes[0], fileHandleForReading.fileDescriptor, EVFILT_READ, EV_ADD, 0, 0, 0);
        EV_SET (&changes[1], fileHandleForSignallingEOF.fileDescriptor, EVFILT_READ, EV_ADD, 0, 0, 0);
        
        while (!shouldTerminate) {
            BOOL hasEOF;
            BOOL hasData;
            NSUInteger availableDataLength;
            BOOL hasPOSIXError;
            NSInteger POSIXError;
            struct kevent event;
        
            int numberOfEvents = kevent (kqueueFileHandle.fileDescriptor, changes, sizeof (changes) / sizeof (changes[0]), &event, 1, NULL);
            
            if (-1 == numberOfEvents) {
                availableDataLength = 0;
                hasData = NO;
                hasEOF = NO;
                hasPOSIXError = YES;
                POSIXError = errno;
            } else if (0 == numberOfEvents) {
                availableDataLength = 0;
                hasData = NO;
                hasEOF = NO;
                hasPOSIXError = NO;
                POSIXError = 0;
            } else if (1 < numberOfEvents) {
                abort ();
            } else if (EV_ERROR & event.flags) {
                availableDataLength = 0;
                hasData = NO;
                hasEOF = NO;
                hasPOSIXError = YES;
                POSIXError = event.data;
            } else if (event.ident == (uintptr_t)fileHandleForReading.fileDescriptor) {
                hasData = 0 != event.data;
                availableDataLength = event.data;
                hasEOF = 0 != (EV_EOF & event.flags);
                hasPOSIXError = NO;
                POSIXError = 0;
            } else if (event.ident == (uintptr_t)fileHandleForSignallingEOF.fileDescriptor) {
                hasData = NO;
                availableDataLength = 0;
                hasEOF = 0 != event.data;
                hasPOSIXError = NO;
                POSIXError = 0;
            } else {
                abort ();
            }
            
            shouldTerminate = hasEOF || hasPOSIXError;
            
            if (hasPOSIXError) {
                CC_LOG_VALUE(POSIXError);
            }
            
            if (hasData) {
                NSData *data = [fileHandleForReading readDataOfLength:availableDataLength];
                [self.outputFileHandle writeData:data];
                if (hasEOF) {
                    [self.inputFileHandle writeData:data];
                } else {
                    [self.inputFileHandleDup writeData:data];
                }
            }
        }        
    }
}

@end
