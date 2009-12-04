//
//  MKPathTransformer.m
//  Levin
//
//  Created by MK on 20.11.09.
//  Copyright 2009 Manfred Kroehnert

/*
 This file is part of Levin.
 
 Levin is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Levin is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Levin.  If not, see <http://www.gnu.org/licenses/>.
 */

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
