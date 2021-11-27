#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AMXFontAutoScalable.h"
#import "AMXFontAutoScale.h"
#import "FontUpdateBlockWrapper.h"
#import "NSObject+AMXFontScale.h"
#import "UIFont+AMXFontScale.h"
#import "UILabel+AMXFontScale.h"
#import "UITextView+AMXFontScale.h"

FOUNDATION_EXPORT double AMXFontAutoScaleVersionNumber;
FOUNDATION_EXPORT const unsigned char AMXFontAutoScaleVersionString[];

