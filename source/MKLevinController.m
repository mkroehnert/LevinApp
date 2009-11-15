//
//  MKLevinController.m
//  Levin
//
//  Created by MK on 15.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKLevinController.h"


@implementation MKLevinController

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self collectAllSwfFilesFromDirectory:[[NSBundle mainBundle] bundlePath]];
    NSURL* swfUrl = [swfFiles lastObject];
    [[webView mainFrame] loadRequest: [NSURLRequest requestWithURL:swfUrl]];
}


- (void) collectAllSwfFilesFromDirectory:(NSString*)searchDirectory
{
    NSDirectoryEnumerator* dirEnum = [[NSFileManager defaultManager] enumeratorAtPath: searchDirectory];
    NSString* file;
    swfFiles = [NSMutableArray arrayWithCapacity:10];
    while ( (file = [dirEnum nextObject]) ) {
        if ([[file pathExtension] isEqualToString: @"swf"])
            [swfFiles addObject: [NSURL URLWithString:[searchDirectory stringByAppendingPathComponent:file]]];
    }
}

@end
