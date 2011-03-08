//
//  PianobarControlAppDelegate.h
//  PianobarControl
//
//  Created by Juan C. Müller on 3/5/11.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#include "PianobarControlModel.h"
#include "PianobarControlController.h"
#import "NSAttributedString+Hyperlink.h"

@interface PianobarControlAppDelegate : NSObject <NSApplicationDelegate> {
	IBOutlet NSMenu *statusMenu;
	
	IBOutlet NSPanel *stationSelection;
	IBOutlet NSTableView *stationsTable;
	IBOutlet NSSearchField *filterBy;
	
	IBOutlet NSPanel *aboutPanel;
	IBOutlet NSTextField *aboutVersion;
	IBOutlet NSTextField *aboutCopyRight;
	IBOutlet NSTextField *aboutUrl;

	NSStatusItem *statusItem;
	
	PianobarControlModel *model;
	PianobarControlController *controller;
}

#pragma mark Actions
- (IBAction) playAction:(id)sender;
- (IBAction) nextAction:(id)sender;
- (IBAction) loveAction:(id)sender;
- (IBAction) banAction:(id)sender;
- (IBAction) showInfoAction:(id)sender;
- (IBAction) chooseStationAction:(id)sender;
- (IBAction) choseStation:(id)sender;
- (IBAction) filterStations:(id)sender;
- (IBAction) showAboutPanel:(id)sender;
#pragma mark -

#pragma mark Utility Methods
- (void) playStationAndHideSelector:(NSString*)stationString;
- (void) raiseApplication;
- (void) setHyperlinkForTextField:(NSTextField*)aTextField url:(NSURL*)anUrl string:(NSString*)aString;
#pragma mark -

#pragma mark Hotkeys
- (void) registerKeys;
- (id) showMenu;
#pragma mark -


- (IBAction) tableViewSelected:(id)sender;

#pragma mark properties
@property(nonatomic, retain) NSMenu *statusMenu;
@property(nonatomic, retain) NSPanel *stationSelection;
@property(nonatomic, retain) NSTableView *stationsTable;
@property(nonatomic, retain) NSSearchField *filterBy;
@property(nonatomic, retain) NSStatusItem *statusItem;

@property(nonatomic, retain) NSPanel *aboutPanel;
@property(nonatomic, retain) NSTextField *aboutVersion;
@property(nonatomic, retain) NSTextField *aboutCopyRight;
@property(nonatomic, retain) NSTextField *aboutUrl;

@property(nonatomic, retain) PianobarControlModel *model;
@property(nonatomic, retain) PianobarControlController *controller;
#pragma mark -

@end

#pragma mark C elements for Hotkey support
id refToSelf;
OSStatus myHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData);
#pragma mark -
