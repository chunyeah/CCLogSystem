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
#import "CCLogStringImp.h"
#import <UIKit/UIGeometry.h>

#pragma mark - Log

enum CCLogImpKind {
    CCLogImpKindStdErr,
    CCLogImpKindNSLog
};

enum CCLogImpKind CCLogImpKind = CCLogImpKindStdErr;

static void CCLogString (CCLocation location, NSString *string)
{
    if (CCLogImpKindStdErr == CCLogImpKind) {
        CCLogStringToStderr(location, string);
    } else {
        CCLogStringToNSLog(location, string);
    }
}

void switchToCCLog (void)
{
    CCLogImpKind = CCLogImpKindStdErr;
}

void switchToNSLog (void)
{
    CCLogImpKind = CCLogImpKindNSLog;
}

void CCLog (CCLocation location, NSString *format, ...)
{
    NSString *string;
    {
        va_list argList;
        va_start(argList, format);
        string = [[NSString alloc] initWithFormat:format arguments:argList];
        va_end(argList);
    }
    CCLogString(location, string);
}

#pragma mark - Description

typedef NSString *(*CCDescriptionHandler) (char const *objcType, va_list argList);

static inline NSString *CCObjectDescription (id object)
{
    NSString *description = [object description];
    return description;
}

static NSString *CCBaseDescriptionHandler (char const *objCType, va_list ap)
{
    NSString *description;
    
    NSString *objCTypeString = [[NSString alloc] initWithUTF8String:objCType];
    
    if ([@"c" isEqualToString: objCTypeString]) {
        int x = va_arg(ap, int);
        if (isprint (x)) {
            description = [NSString stringWithFormat:@"'%c'", x];
        } else {
            description = [NSString stringWithFormat:@"%d", (int)x];
        }
    } else if ([@"i" isEqualToString:objCTypeString]) {
        int i = va_arg(ap, int);
        description = [NSString stringWithFormat:@"%d", i];
    } else if ([@"s" isEqualToString:objCTypeString]) {
        int s = va_arg(ap, int);
        description = [NSString stringWithFormat:@"%d", s];
    }else if ([@"l" isEqualToString:objCTypeString]) {
        long l = va_arg(ap, long);
        description = [NSString stringWithFormat:@"%ld", l];
    } else if ([@"q" isEqualToString:objCTypeString]) {
        long long q = va_arg(ap, long long);
        description = [NSString stringWithFormat:@"%lld", q];
    } else if ([@"C" isEqualToString:objCTypeString]) {
        int C = va_arg(ap, int);
        description = [NSString stringWithFormat:@"%d", C];
    } else if ([@"I" isEqualToString:objCTypeString]) {
        unsigned int I = va_arg(ap, unsigned int);
        description = [NSString stringWithFormat:@"%u", I];
    } else if ([@"S" isEqualToString:objCTypeString]) {
        int S = va_arg(ap, int);
        description = [NSString stringWithFormat:@"%d", S];
    } else if ([@"L" isEqualToString:objCTypeString]) {
        unsigned long L = va_arg(ap, unsigned long);
        description = [NSString stringWithFormat:@"%lu", L];
    } else if ([@"Q" isEqualToString:objCTypeString]) {
        unsigned long long Q = va_arg(ap, unsigned long long);
        description = [NSString stringWithFormat:@"%llu", Q];
    } else if ([@"f" isEqualToString:objCTypeString]) {
        double f = va_arg(ap, double);
        description = [NSString stringWithFormat:@"%f", f];
    } else if ([@"d" isEqualToString:objCTypeString]) {
        double d = va_arg(ap, double);
        description = [NSString stringWithFormat:@"%g", d];
    } else if ([@"*" isEqualToString:objCTypeString]) {
        char * point = va_arg(ap, char *);
        description = [NSString stringWithFormat:@"%s", point];
    } else if ([@"r*" isEqualToString:objCTypeString]) {
        char const * constPoint = va_arg(ap, char const *);
        description = [NSString stringWithFormat:@"%s", constPoint];
    } else if ([@"^v" isEqualToString:objCTypeString]) {
        void * _void = va_arg(ap, void *);
        description = [NSString stringWithFormat:@"%p", _void];
    } else if ([@"r^v" isEqualToString:objCTypeString]) {
        void const * _constVoid = va_arg(ap, void const *);
        description = [NSString stringWithFormat:@"%p", _constVoid];
    } else if ([[NSString stringWithUTF8String:"@"] isEqualToString:objCTypeString]) {
        id x = va_arg(ap, id);
        description = CCObjectDescription(x);
    } else if ([[NSString stringWithUTF8String:"@?"] isEqualToString:objCTypeString]) {
        id x = va_arg(ap, id);
        description = CCObjectDescription(x);
    } else if ([[NSString stringWithUTF8String:":"] isEqualToString:objCTypeString]) {
        SEL sel = va_arg(ap, SEL);
        description = NSStringFromSelector(sel);
    } else if ([[NSString stringWithUTF8String:"#"] isEqualToString:objCTypeString]) {
        id class = va_arg(ap, id);
        description = NSStringFromClass(class);
    } else if ([[NSString stringWithUTF8String:@encode (NSRange)] isEqualToString:objCTypeString]) {
        NSRange range = va_arg(ap, NSRange);
        description = NSStringFromRange(range);
    } else if ([objCTypeString hasPrefix: @"^{"]) {
        void *p = va_arg(ap, void *);
        description = [NSString stringWithFormat:@"<%@>(%p)", objCTypeString, p];
    } else {
        if ([objCTypeString hasPrefix:@"{CGRect"]) {
            CGRect rect = va_arg(ap, CGRect);
            description = NSStringFromCGRect(rect);
        } else if ([objCTypeString hasPrefix:@"{CGVector"]) {
            CGVector vector = va_arg(ap, CGVector);
            description = NSStringFromCGVector(vector);
        } else if ([objCTypeString hasPrefix:@"{CGSize"]) {
            CGSize size = va_arg(ap, CGSize);
            description = NSStringFromCGSize(size);
        } else if ([objCTypeString hasPrefix:@"{CGAffineTransform"]) {
            CGAffineTransform transform = va_arg(ap, CGAffineTransform);
            description = NSStringFromCGAffineTransform(transform);
        } else if ([objCTypeString hasPrefix:@"{UIEdgeInsets"]) {
            UIEdgeInsets insets = va_arg(ap, UIEdgeInsets);
            description = NSStringFromUIEdgeInsets(insets);
        } else if ([objCTypeString hasPrefix:@"{UIOffset"]) {
            UIOffset offset = va_arg(ap, UIOffset);
            description = NSStringFromUIOffset(offset);
        } else {
            description = [NSString stringWithFormat:@"<%@>(?)", objCTypeString];
        }
    }
    return description;
}

static CCDescriptionHandler CCCurrentDescriptionHandler;

CCDescriptionHandler CCGetCurrentDescriptionHandler (void)
{
    CCDescriptionHandler currentDescriptionHandler;
    if (!CCCurrentDescriptionHandler) {
        CCCurrentDescriptionHandler = CCBaseDescriptionHandler;
    }
    currentDescriptionHandler = CCCurrentDescriptionHandler;
    return currentDescriptionHandler;
}

void CCSetCurrentDescriptionHandler (CCDescriptionHandler handler)
{
    CCCurrentDescriptionHandler = handler;
}

NSString *CCDescriptionWithObjCTypeAndArgs (char const *objCType, ...)
{
    NSString *description;
    
    va_list ap;
    va_start(ap, objCType);
    
    description = CCGetCurrentDescriptionHandler() (objCType, ap);
    
    va_end(ap);
    
    return description;
}