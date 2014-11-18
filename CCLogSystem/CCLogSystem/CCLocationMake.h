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

typedef NS_ENUM(NSInteger, CCLocationStyle) {
    CCLocationStyleShort,   // Only point FUNCTION name
    CCLocationStyleLong,    // Point FILE FUNCTION LINE and Thread
};

CC_EXTERN CCLocation CCLocationNowhere;

CC_EXTERN NSString *CCStringFromLocation(CCLocation location);

CC_EXTERN NSString *CCStringFromLocationWithStyle(CCLocation location, CCLocationStyle locationStyle);

CC_EXTERN NSString *CCLogPrefixFromLocation (CCLocation location);
