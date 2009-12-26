//
//  MKLevinController.m
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

#import "MKLevinController.h"
#import "NSStringLevinAdditions.h"
#import "WebViewLevinAdditions.h"


@implementation MKLevinController

NSString* const SWF_FILES_CONTROLLER_KEY = @"selection";
NSString* const SCAN_PATH_CONTROLLER_KEY = @"content";
NSString* const USERDEFAULTS_LAST_OPEN_FILE = @"lastOpenFile";


/**
 *
 */
- (id) init
{
    self = [super init];
    if (self)
    {
        swfFiles = [NSMutableArray arrayWithCapacity:10];
        oldUserdefaultsScanPaths = nil;
    }

    return self;
}


/**
 * Remove self from the swfFilesController observer list
 * and also remove self from the scanPathController observer list.
 */
- (void) dealloc
{
    [swfFilesController removeObserver:self forKeyPath:SWF_FILES_CONTROLLER_KEY];
    [scanPathController removeObserver:self forKeyPath:SCAN_PATH_CONTROLLER_KEY];
    [oldUserdefaultsScanPaths release];
    [super dealloc];
}


/**
 * Load the Preferences.nib and make it the frontmost window.
 */
- (IBAction) showPreferences:(id)sender
{
    [NSBundle loadNibNamed:@"Preferences" owner:self];
    
    if ((nil != preferencesPanel))
        [preferencesPanel makeKeyAndOrderFront:sender];
}


/**
 * Add self to the observer list of the scanPathController and swfFilesController.
 * Create a copy of the scanPathControllers content and prompt for a directory
 * to scan if no scanPaths have been stored.
 * Scan all directories if there are some entries in the scanPaths userdefaults.
 * Finally select the file which was open at the last launch.
 */
- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [scanPathController addObserver:self forKeyPath:SCAN_PATH_CONTROLLER_KEY options:NSKeyValueObservingOptionNew context:nil];
    // make a copy for later comparison in observerValueForKeyPath:ofObject:change:context:
    [oldUserdefaultsScanPaths release];
    oldUserdefaultsScanPaths = [[scanPathController content] mutableCopy];
    
    if (0 == [[scanPathController arrangedObjects] count])
        [self promptForScanpath:nil];
    else
        [[scanPathController arrangedObjects] makeObjectsPerformSelector:@selector(addDetectedSwfFilesToArrayController:) withObject:swfFilesController];

    [swfFilesController addObserver:self forKeyPath:SWF_FILES_CONTROLLER_KEY options:NSKeyValueObservingOptionNew context:nil];
    // select last opened file and trigger a change notification to load the file
    NSString* lastOpenFile = [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULTS_LAST_OPEN_FILE];
    if (0 < [lastOpenFile length])
        [swfFilesController setSelectedObjects:[NSArray arrayWithObject:lastOpenFile]];
}


/**
 * Store the last selected swf file in the userdefaults
 */
- (void) applicationWillTerminate:(NSNotification *)aNotification
{
    [[NSUserDefaults standardUserDefaults] setObject: [[swfFilesController selectedObjects] lastObject] forKey:USERDEFAULTS_LAST_OPEN_FILE];
}


/**
 * Show an NSOpenPanel sheet to select the directory to scan.
 */
- (IBAction) promptForScanpath:(id)sender
{
    NSOpenPanel* scanpathPanel = [NSOpenPanel openPanel];
    
    [scanpathPanel setCanChooseFiles:NO];
    [scanpathPanel setCanChooseDirectories:YES];
    [scanpathPanel setAllowsMultipleSelection:NO];
    [scanpathPanel setDirectory:NSHomeDirectory()];
    [scanpathPanel setPrompt:@"Scan Directory"];
    [scanpathPanel setTitle:@"Select directory to scan"];

    [scanpathPanel beginSheetForDirectory:nil
                                     file:nil
                           modalForWindow:mainWindow
                            modalDelegate:self
                           didEndSelector:@selector(filePanelDidEnd:returnCode:contextInfo:)
                              contextInfo:nil];
    
    [NSApp runModalForWindow:scanpathPanel];
    [NSApp endSheet:scanpathPanel];
}


/**
 * Delegat selector to handle the actions from the NSOpenPanel sheet.
 * Stores the selected directory in the arraycontroller if the OK button has been pressed
 * and the pathname is not empty.
 */
- (void) filePanelDidEnd:(NSOpenPanel*)sheet
              returnCode:(int)returnCode
             contextInfo:(void*)contextInfo
{
    NSString* selectedScanPath = @"";

    if (NSOKButton == returnCode)
        selectedScanPath = [sheet directory];
    
    if (0 != [selectedScanPath length])
        [scanPathController addObject:selectedScanPath];
    
    [NSApp stopModalWithCode:returnCode];
}


/**
 * Call loadFileAtPath: on the webView with the current selection of the swfFilesController
 * if the object is notified with an SWF_FILES_CONTROLLER_KEY \p keyPath and \p object
 * is the swfFilesController. Remove the path from the swfFilesController if it could not be loaded.
 *
 * If \p keyPath is SCAN_PATH_CONTROLLER_KEY and the object is the scanPathController
 * then compare the size of the scanPathControllers content and the copy stored in
 * oldUserdefaultsScanPaths (necessary because no other notification than NSKeyValueChangeSetting
 * is returned in the change dictionary).
 * If the old size is smaller than the new one, scan the added directory for swfFiles
 * otherwise a directory has been removed.
 * Afterwards create a copy of the new userdefaults array.
 */
- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if ([keyPath isEqual:SWF_FILES_CONTROLLER_KEY] && (object == swfFilesController))
    {
        if (0 < [[swfFilesController selectedObjects] count])
        {
            id selectedSwfFile = [[swfFilesController selectedObjects] lastObject];
            if (![webView loadFileAtPath:selectedSwfFile])
                [swfFilesController removeObject:selectedSwfFile];
        }
    }
    else if([keyPath isEqual:SCAN_PATH_CONTROLLER_KEY] && (object == scanPathController))
    {
        NSMutableArray* userdefaultsScanPaths = [[scanPathController content] mutableCopy];
        if ([oldUserdefaultsScanPaths count] > [userdefaultsScanPaths count])
        {
            // calculate the difference between old and new array
            [oldUserdefaultsScanPaths removeObjectsInArray:userdefaultsScanPaths];
            NSLog(@"Removed path: %@", [oldUserdefaultsScanPaths lastObject]);
        }
        else
        {
            // calculate the difference between old and new array
            [userdefaultsScanPaths removeObjectsInArray:oldUserdefaultsScanPaths];
            NSLog(@"Added scan Path:%@", [userdefaultsScanPaths lastObject]);
            [[userdefaultsScanPaths lastObject] addDetectedSwfFilesToArrayController:swfFilesController];
        }
        [oldUserdefaultsScanPaths release];
        oldUserdefaultsScanPaths = [[scanPathController content] mutableCopy];
        [userdefaultsScanPaths release];
    }
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
