//
//  CCFileOutputRedirectionController.h
//  CCLogSystem
//
//  Created by Chun Ye on 10/29/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCFileOutputRedirectionController

@property (nonatomic, strong) NSFileHandle *inputFileHandle;
@property (nonatomic, strong) NSFileHandle *outputFileHandle;

- (void)startRecordLog;

- (void)stopRecordLog;

@end
