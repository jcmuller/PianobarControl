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

@property(nonatomic, retain) PBCModel *model;
@property(nonatomic, retain) NSStatusItem *statusItem;
@property(nonatomic, retain) PBCSongInfoParser *songInfo;

@property(nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property(nonatomic, retain) IBOutlet NSMenuItem *currentSong;
@property(nonatomic, retain) IBOutlet NSMenuItem *sleepDisabledMenuItem;

@property(nonatomic, retain) IBOutlet NSPanel *stationSelection;
@property(nonatomic, retain) IBOutlet NSTableView *stationsTable;
@property(nonatomic, retain) IBOutlet NSSearchField *filterBy;

@property(nonatomic, retain) IBOutlet NSPanel *aboutPanel;
@property(nonatomic, retain) IBOutlet NSTextField *aboutVersion;
@property(nonatomic, retain) IBOutlet NSTextField *aboutCopyRight;
@property(nonatomic, retain) IBOutlet NSTextField *aboutUrl;

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

- (NSInteger) ensureValidRowNumber:(NSInteger)rowNumber;

@end

#pragma mark C elements for Hotkey support
id refToSelf;
OSStatus myHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData);
#pragma mark -
