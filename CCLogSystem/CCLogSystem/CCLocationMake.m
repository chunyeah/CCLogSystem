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

#import "CCLocationMake.h"

#pragma mark - Private

static NSString *CCStringFromSourceFilePath(const char *file)
{
    NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:file length:strlen(file)];
    NSString *string = [path lastPathComponent];
    return string;
}

static NSString *CCStringWithSourceLocationFromLocation(CCLocation location)
{
    NSString *string;
    if (!memcmp(&location, &CCLocationNowhere, sizeof(location))) {
        string = @"";
    } else {
        string = [NSString stringWithFormat:@"%@ at %d (%s)", CCStringFromSourceFilePath(location.file), location.line, location.func];
    }
    return string;
}

#pragma mark - Public

NSString *CCLogPrefixFromLocation (CCLocation location)
{
    NSString *sourceLocationDescription = CCStringWithSourceLocationFromLocation(location);
    NSArray *stringArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@", [NSThread currentThread].description], (sourceLocationDescription.length > 0 ? [NSString stringWithFormat:@"%@:", sourceLocationDescription] : [NSNull null]), nil];
    NSString *string = [stringArray componentsJoinedByString:@" "];
    return string;
}

NSString *CCStringFromLocationWithStyle(CCLocation location, CCLocationStyle locationStyle)
{
    NSString *string;
    switch (locationStyle) {
        case CCLocationStyleLong:
        {
            NSString *sourceLocationDescription = CCStringWithSourceLocationFromLocation(location);
            NSArray *stringArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@", [NSThread currentThread].description], (sourceLocationDescription.length > 0 ? [NSString stringWithFormat:@"%@", sourceLocationDescription] : [NSNull null]), nil];
            string = [stringArray componentsJoinedByString:@" "];
        }
            break;
        case CCLocationStyleShort:
            string = [NSString stringWithFormat:@"%s", location.func];
            break;
        default:
            abort();
            break;
    }
    return string;
}

NSString *CCStringFromLocation(CCLocation location)
{
    return CCStringFromLocationWithStyle(location, CCLocationStyleLong);
}

CCLocation CCLocationNowhere = {
    CC_INITIALIZED_FIELD(file, ""),
    CC_INITIALIZED_FIELD(line, 0),
    CC_INITIALIZED_FIELD(func, "")
};


