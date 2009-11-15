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
    [[webView mainFrame] loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: @"http://www.heise.de"]]];
}
@end
