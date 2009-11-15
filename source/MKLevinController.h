//
//  MKLevinController.h
//  Levin
//
//  Created by MK on 15.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MKLevinController : NSObject {
    IBOutlet WebView* webView;
    NSMutableArray* swfFiles;
}

- (void) applicationDidFinishLaunching:(NSNotification*)aNotification;
- (void) collectAllSwfFilesFromDirectory:(NSString*)searchDirectory;

@end
