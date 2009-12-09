//
//  MKLevinController.h
//  Levin
//
//  Created by MK on 15.11.09.
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

#import <Cocoa/Cocoa.h>


extern NSString* const SWF_FILES_CONTROLLER_KEY;
extern NSString* const SCAN_PATH_CONTROLLER_KEY;

@interface MKLevinController : NSObject
{
    IBOutlet WebView* webView;
    IBOutlet NSArrayController* swfFilesController;
    IBOutlet NSArrayController* scanPathController;
    IBOutlet NSWindow* mainWindow;
    IBOutlet NSPanel* preferencesPanel;
    NSMutableArray* swfFiles;
    NSMutableArray* oldUserdefaultsScanPaths;
}

- (IBAction) showPreferences:(id)sender;
- (IBAction) promptForScanpath:(id)sender;

- (void) applicationDidFinishLaunching:(NSNotification*)aNotification;
- (void) filePanelDidEnd:(NSOpenPanel*)sheet returnCode:(int)returnCode contextInfo:(void*)contextInfo;

@end
