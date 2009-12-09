//
//  NSStringLevinAdditions.m
//  Levin
//
//  Created by MK on 09.12.09.
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

#import "NSStringLevinAdditions.h"


@implementation NSString (LevinAdditions)

/**
 * Scan through the directory at the location of self and add all swf files found
 * to the array controller passed in through \p anArrayController.
 *
 * \param anArrayController controller to add the found swf files to.
 */
- (void) addDetectedSwfFilesToArrayController:(NSArrayController*)anArrayController
{
    // returns an enumerator returning nil for first call to nextObject if self isn't an accessible directory
    NSDirectoryEnumerator* dirEnum = [[NSFileManager defaultManager] enumeratorAtPath: self];
    NSString* file;
    while ( (file = [dirEnum nextObject]) )
    {
        if ([[[file pathExtension] lowercaseString] isEqualToString: @"swf"])
        {
            NSLog(@"Found: %@\n", file);
            [anArrayController addObject: [self stringByAppendingPathComponent:file]];
        }
    }
}

@end
