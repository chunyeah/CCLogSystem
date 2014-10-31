//
//  CCLocation.h
//  CCLogSystem
//
//  Created by Chun Ye on 10/29/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import "CCLog.h"

typedef NS_ENUM(NSInteger, CCLocationStyle) {
    CCLocationStyleShort,   // Only point FUNCTION name
    CCLocationStyleLong,    // Point FILE FUNCTION LINE and Thread
};

CC_EXTERN CCLocation CCLocationNowhere;

CC_EXTERN NSString *CCStringFromLocation(CCLocation location);

CC_EXTERN NSString *CCStringFromLocationWithStyle(CCLocation location, CCLocationStyle locationStyle);

CC_EXTERN NSString *CCLogPrefixFromLocation (CCLocation location);
