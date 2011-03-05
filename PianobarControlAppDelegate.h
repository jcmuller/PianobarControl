//
//  PianobarControlAppDelegate.h
//  PianobarControl
//
//  Created by Juan C. Müller on 3/5/11.
//  Copyright 2011 Challenge Post. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PianobarControlAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow     *window;
	NSStatusItem *statusItem;
	NSMenu       *statusMenu;
	
	NSMenuItem *about;
	NSMenuItem *play;
	NSMenuItem *next;
	NSMenuItem *toggle;
	NSMenuItem *love;
	NSMenuItem *ban;
	NSMenuItem *info;
	NSMenuItem *choose;
	NSMenuItem *quit;
}

- (void) activateStatusMenu;
- (void) addSubMenus;
- (void) aboutDockAction:(id)sender;
- (void) performAction:(id)action;

- (void) playAction:(id)sender;
- (void) quitAction:(id)sender;
- (void) nextAction:(id)sender;
- (void) loveAction:(id)sender;
- (void) banAction:(id)sender;
- (void) showInfoAction:(id)sender;
- (void) chooseStationAction:(id)sender;

@property (assign) IBOutlet NSWindow *window;

@end
