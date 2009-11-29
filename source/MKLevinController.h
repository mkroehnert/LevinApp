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
    IBOutlet NSArrayController* scanPathController;
    IBOutlet NSWindow* mainWindow;
    IBOutlet NSPanel* preferencesPanel;
    NSMutableArray* swfFiles;
}

- (IBAction) showPreferences:(id)sender;
- (IBAction) promptForScanpath:(id)sender;

- (void) applicationDidFinishLaunching:(NSNotification*)aNotification;
- (void) collectAllSwfFilesFromDirectory:(NSString*)searchDirectory;
- (void) loadFileAtPathIntoWebView:(NSString*)swfPath;
- (void) filePanelDidEnd:(NSOpenPanel*)sheet returnCode:(int)returnCode contextInfo:(void*)contextInfo;

@end
