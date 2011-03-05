//
//  PianobarControlAppDelegate.m
//  PianobarControl
//
//  Created by Juan C. Müller on 3/5/11.
//  Copyright 2011 Challenge Post. All rights reserved.
//

#import "PianobarControlAppDelegate.h"

@implementation PianobarControlAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self activateStatusMenu];
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
	[window close];
}

- (void)activateStatusMenu {
	bar     = [NSStatusBar systemStatusBar];
	theItem = [bar statusItemWithLength:NSVariableStatusItemLength];
	theMenu = [[NSMenu alloc] initWithTitle: @"Hello, world!"];
	[self addSubMenus];
	
	[theMenu setAutoenablesItems:NO];
	[theItem retain];
	[theItem setImage:[NSImage imageNamed:@"pandora-logo-16.png"]];
	[theItem setHighlightMode:YES];
	[theItem setMenu:theMenu];
}

- (void)addSubMenus {
	// Instantiate Menu items
	quit   = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Quit"         action:@selector(quitAction:) keyEquivalent:@""];
	play   = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Play - Pause" action:@selector(playAction:) keyEquivalent:@""];
	next   = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Next"         action:@selector(nextAction:) keyEquivalent:@""];
	love   = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Love"         action:@selector(loveAction:) keyEquivalent:@""];
	ban    = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Ban"          action:@selector(banAction:)  keyEquivalent:@""];

	about  = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"About Pianobar Control" action:@selector(aboutDockAction:) keyEquivalent:@""];
	choose = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Choose Station"         action:@selector(chooseStationAction:) keyEquivalent:@""];
	info   = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Show Song Info"         action:@selector(showInfoAction:) keyEquivalent:@""];
	
	// Set targets
	[about setTarget: self];

	// Set icons
	[about  setImage:[NSImage imageNamed:@"pandora-logo-16.png"]];
	[love   setImage:[NSImage imageNamed:@"thumbs_up.png"]];
	[ban    setImage:[NSImage imageNamed:@"thumbs_down.png"]];
	[play   setImage:[NSImage imageNamed:@"media_play_pause_resume.png"]];
	[next   setImage:[NSImage imageNamed:@"media_next.png"]];
	[info   setImage:[NSImage imageNamed:@"information.png"]];
	[quit   setImage:[NSImage imageNamed:@"exit.png"]];
	[choose setImage:[NSImage imageNamed:@"view_choose.png"]];
	
	// Add menu items
	[theMenu addItem:play];
	[theMenu addItem:next];
	[theMenu addItem:love];
	[theMenu addItem:ban];
	[theMenu addItem:choose];
	[theMenu addItem:info];
	[theMenu addItem:[NSMenuItem separatorItem]];
	[theMenu addItem:about];
	[theMenu addItem:[NSMenuItem separatorItem]];
	[theMenu addItem:quit];

	// Release items
	[about release];
	[play release];
	[next release];
	[love release];
	[ban release];
	[choose release];
	[info release];
	[quit release];

}

- (void)aboutDockAction:(id)sender {
	[[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:self];
}

- (void)playAction:(id)sender {
	NSString *action = @"p";
	[self performAction:action];
}

- (void)nextAction:(id)sender {
	NSString *action = @"n";
	[self performAction:action];
}

- (void)loveAction:(id)sender {
	NSString *action = @"+";
	[self performAction:action];
}

- (void)banAction:(id)sender {
	NSString *action = @"-";
	[self performAction:action];
}

- (void)chooseStationAction:(id)sender {
	system("PianobarControl.app/Contents/Resources/pianobar-choose-station");

	NSArray *apps;
	apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"org.x.X11"];
	
	NSRunningApplication *x11 = [apps objectAtIndex:0];
	[x11 activateWithOptions:NSApplicationActivateAllWindows];
}

- (void)showInfoAction:(id)sender {
	NSString *action = @"e";
	[self performAction:action];
}

- (void)quitAction:(id)sender {
	exit(0);
}

- (void)performAction:(id)action {
	NSString *filenameStr = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), @".config/pianobar/ctl"];
	NSError	 *error;
	
	if(![action writeToFile:filenameStr atomically:NO encoding:NSUTF8StringEncoding error:&error]) {
		NSLog(@"We have a problem: %@\r\n", [error localizedFailureReason]);
	}
}

@end
