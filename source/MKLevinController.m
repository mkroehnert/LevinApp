//
//  MKLevinController.m
//  Levin
//
//  Created by MK on 15.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKLevinController.h"


@implementation MKLevinController

- (id) init
{
    self = [super init];
    if (self)
        swfFiles = [NSMutableArray array];
    return self;
}


- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self collectAllSwfFilesFromDirectory:[[NSBundle mainBundle] bundlePath]];
    NSString* swfPath = [[swfFilesController selectedObjects] lastObject];
    [[webView mainFrame] loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:swfPath]]];
}


- (void) collectAllSwfFilesFromDirectory:(NSString*)searchDirectory
{
    NSDirectoryEnumerator* dirEnum = [[NSFileManager defaultManager] enumeratorAtPath: searchDirectory];
    NSString* file;
    while ( (file = [dirEnum nextObject]) ) {
        if ([[file pathExtension] isEqualToString: @"swf"])
        {
            NSLog(@"Found: %@\n", file);
            [swfFilesController addObject: [searchDirectory stringByAppendingPathComponent:file]];
        }
    }
}

@end
