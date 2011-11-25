//
//  PianobarControlAppDelegate.h
//  PianobarControl
//
//  Created by Juan C. Müller on 3/5/11.
//  Copyright (c) 2011 Juan C. Muller, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <IOKit/pwr_mgt/IOPMLib.h>
#import "PBCModel.h"
#import "NSAttributedString+Hyperlink.h"
#import "PBCSongInfoParser.h"

@interface PBCAppDelegate : NSObject <NSApplicationDelegate>
{
	PBCModel *model;
	NSStatusItem *statusItem;
	PBCSongInfoParser *songInfo;
	
	BOOL sleepEnabled;
	IOPMAssertionID sleepAssertionID;

	IBOutlet NSMenu *statusMenu;
	
	IBOutlet NSMenuItem *currentSong;
	IBOutlet NSMenuItem *sleepDisabledMenuItem;
	
	IBOutlet NSPanel *stationSelection;
	IBOutlet NSTableView *stationsTable;
	IBOutlet NSSearchField *filterBy;
	IBOutlet NSPanel *aboutPanel;
	IBOutlet NSTextField *aboutVersion;
	IBOutlet NSTextField *aboutCopyRight;
	IBOutlet NSTextField *aboutUrl;	
}

@property(nonatomic, retain) PBCModel *model;
@property(nonatomic, retain) NSMenu *statusMenu;
@property(nonatomic, retain) NSPanel *stationSelection;
@property(nonatomic, retain) NSTableView *stationsTable;
@property(nonatomic, retain) NSSearchField *filterBy;
@property(nonatomic, retain) NSStatusItem *statusItem;

@property(nonatomic, retain) NSPanel *aboutPanel;
@property(nonatomic, retain) NSTextField *aboutVersion;
@property(nonatomic, retain) NSTextField *aboutCopyRight;
@property(nonatomic, retain) NSTextField *aboutUrl;

@property(nonatomic, retain) NSMenuItem *currentSong;
@property(nonatomic, retain) NSMenuItem *sleepDisabledMenuItem;

@property(nonatomic, retain) PBCSongInfoParser *songInfo;

- (void) performAction:(NSString *)action;
- (void) playStation:(NSString*)stationId;
- (void) playStationAndHideSelector:(NSString*)stationString;
- (void) raiseApplication;
- (void) setHyperlinkForTextField:(NSTextField*)aTextField
							  url:(NSURL*)anUrl
						   string:(NSString*)aString;

/* This will, how did you guess, set the current song title */
- (void) setCurrentSongTitle:(id)sender;
- (id) showMenu;

- (IBAction) playAction:(id)sender;
- (IBAction) nextAction:(id)sender;
- (IBAction) loveAction:(id)sender;
- (IBAction) banAction:(id)sender;
- (IBAction) showInfoAction:(id)sender;
- (IBAction) showLyricsAction:(id)sender;
- (IBAction) chooseStationAction:(id)sender;
- (IBAction) toggleSleepAllow:(id)sender;

- (IBAction) choseStation:(id)sender;
- (IBAction) filterStations:(id)sender;
- (IBAction) showAboutPanel:(id)sender;
- (IBAction) tableViewSelected:(id)sender;
- (IBAction) doubleClicked:(id)sender;

- (void) registerKeys;

- (void) alternateIcon;
- (void) resetIcon:(id)sender;

@end

#pragma mark C elements for Hotkey support
id refToSelf;
OSStatus myHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData);
#pragma mark -
