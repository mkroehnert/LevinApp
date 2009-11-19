//
//  MKPathTransformer.m
//  Levin
//
//  Created by MK on 20.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKPathTransformer.h"


/**
 * This ValueTransformer transforms a path into a filename or a directory (the last path component).
 */
@implementation MKPathTransformer

/**
 * \return [NSString class]
 */
+ (Class) transformedValueClass
{
    return [NSString class];
}


/**
 * \return NO
 */
+ (BOOL) allowsReverseTransformation
{
    return NO;
}


/**
 * \return last path component if possible and return nil for nil \p value or raise an exception if \value is not a path
 */
- (id) transformedValue:(id)value
{
    if (nil == value)
        return nil;
    
    if (![value respondsToSelector: @selector(componentsSeparatedByString:)])
    {
        [NSException raise: NSInternalInconsistencyException
                    format: @"Value (%@) does not respond to -componentsSeparatedByString:.", [value class]];
    }
    
    return [[value componentsSeparatedByString:@"/"] lastObject];
}

@end
