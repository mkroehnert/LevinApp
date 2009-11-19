//
//  MKPathTransformer.h
//  Levin
//
//  Created by MK on 20.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MKPathTransformer : NSValueTransformer
{
}

+ (Class) transformedValueClass;
+ (BOOL) allowsReverseTransformation;
- (id) transformedValue:(id)value;

@end
