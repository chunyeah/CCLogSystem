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

// Define
#ifdef __cplusplus
#define CC_EXTERN  extern "C" __attribute__((visibility ("default")))
#else
#define CC_EXTERN  extern __attribute__((visibility ("default")))
#endif

#ifdef __cplusplus
# if !defined __clang__
#  define CC_INITIALIZED_FIELD(name, ...) \
name: __VA_ARGS__
# else
#  define CC_INITIALIZED_FIELD(name, ...) \
.name = __VA_ARGS__
# endif
#else
# define CC_INITIALIZED_FIELD(name, ...) \
.name = __VA_ARGS__
#endif

// Location
typedef struct {
    char const *file;
    int line;
    char const *func;
} CCLocation;

static inline CCLocation CCLocationMake (char const *file, int line, char const *func)
{
    CCLocation location;
    location.file = file;
    location.line = line;
    location.func = func;
    
    return location;
}

#define CC_LOCATION() \
CCLocationMake (__FILE__, __LINE__, __func__)

// Log
CC_EXTERN void CCLog (CCLocation location, NSString *format, ...);

CC_EXTERN void switchToCCLog (void);

CC_EXTERN void switchToNSLog (void);

// Description
CC_EXTERN NSString *CCDescriptionWithObjCTypeAndArgs (char const *objCType, ...);

#define CC_STRING_FOR_LOG_VALUE(...) \
[NSString stringWithFormat:@"%s: %@", \
#__VA_ARGS__, \
CC_DESCRIPTION_FOR_VALUE(__VA_ARGS__)]

#define CC_DESCRIPTION_FOR_VALUE(...) \
({ \
CCDescriptionWithObjCTypeAndArgs ( \
@encode (__typeof__ (__VA_ARGS__)), \
(__VA_ARGS__)); \
})
