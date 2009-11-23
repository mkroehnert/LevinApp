//
//  MKLevinController.h
//  Levin
//
//  Created by MK on 15.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


extern NSString* const SWF_FILES_CONTROLLER_KEY;

@interface MKLevinController : NSObject {
    IBOutlet WebView* webView;
    IBOutlet NSArrayController* swfFilesController;
    IBOutlet NSWindow* mainWindow;
    NSMutableArray* swfFiles;
    NSString* selectedScanPath;
}

- (void) applicationDidFinishLaunching:(NSNotification*)aNotification;
- (void) collectAllSwfFilesFromDirectory:(NSString*)searchDirectory;
- (void) loadFileAtPathIntoWebView:(NSString*)swfPath;
- (void) promptForScanpath;
- (void) filePanelDidEnd:(NSOpenPanel*)sheet returnCode:(int)returnCode contextInfo:(void*)contextInfo;

@end
