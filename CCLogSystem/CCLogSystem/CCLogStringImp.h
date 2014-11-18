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

#import "CCLog.h"

// Use fprintf
CC_EXTERN void CCLogStringToStderr (CCLocation location, NSString *string);

// Use NSLog
CC_EXTERN void CCLogStringToNSLog (CCLocation location, NSString *string);
