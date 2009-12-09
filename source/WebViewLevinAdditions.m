//
//  WebViewLevinAdditions.m
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

#import "WebViewLevinAdditions.h"


@implementation WebView (LevinAdditions)

/**
 * Create an NSURLRequest from \p aPath and load it into the webView.
 * Return without trying to load the file if it does not exist.
 *
 * \param swfPath file to load into the webView.
 * \return YES if loading was successful and NO otherwise
 */
- (BOOL) loadFileAtPath:(NSString*)aPath
{
    NSLog(@"Loading: %@\n", aPath);
    if (! [[NSFileManager defaultManager] fileExistsAtPath:aPath])
        return NO;

    [[self mainFrame] loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:aPath]]];
    return YES;
}

@end
