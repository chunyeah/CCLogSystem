//
//  CCLogStringImp.h
//  CCLogSystem
//
//  Created by Chun Ye on 10/29/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import "CCLog.h"

// Use fprintf
CC_EXTERN void CCLogStringToStderr (CCLocation location, NSString *string);

// Use NSLog
CC_EXTERN void CCLogStringToNSLog (CCLocation location, NSString *string);
