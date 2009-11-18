//
//  MKLevinController.m
//  Levin
//
//  Created by MK on 15.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKLevinController.h"


@implementation MKLevinController

NSString* const SWF_FILES_CONTROLLER_KEY = @"selection";


/**
 *
 */
- (id) init
{
    self = [super init];
    if (self)
        swfFiles = [NSMutableArray arrayWithCapacity:10];

    return self;
}


/**
 * Remove self from the swfFilesController observer list.
 */
- (void) dealloc
{
    [swfFilesController removeObserver:self forKeyPath:SWF_FILES_CONTROLLER_KEY];
    [super dealloc];
}


/**
 * Retrieve all swf files from specified directory and add self to the observer list
 * of swfFilesController.
 */
- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self collectAllSwfFilesFromDirectory:[[NSBundle mainBundle] bundlePath]];
    [swfFilesController addObserver:self forKeyPath:SWF_FILES_CONTROLLER_KEY options:NSKeyValueObservingOptionNew context:nil];
}


/**
 * Scan through \p searchDirectory and add all swf files found to the swfFiles array
 * through the swfFilesController
 *
 * \param searchDirectory directory in which to search for swf files
 */
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


/**
 * Create an NSURLRequest from \p swfPath and load it into the webView.
 *
 * \param swfPath file to load into the webView.
 */
- (void) loadFileAtPathIntoWebView:(NSString*)swfPath
{
    NSLog(@"Loading: %@\n", swfPath);
    // TODO: handle not existent path
    [[webView mainFrame] loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:swfPath]]];
}


/**
 * Call loadFileAtPathIntoWebView with the current selection of the swfFilesController
 * if the object is notified with an SWF_FILES_CONTROLLER_KEY keyPath.
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqual:SWF_FILES_CONTROLLER_KEY])
    {
        [self loadFileAtPathIntoWebView:[[swfFilesController selectedObjects] lastObject]];
    }
    // Don't send to super!!!
}

@end
