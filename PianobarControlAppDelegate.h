//
//  PianobarControlAppDelegate.h
//  PianobarControl
//
//  Created by Juan C. Müller on 3/5/11.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "PianobarControlModel.h"
#import "NSAttributedString+Hyperlink.h"
#import "JMSongInfoParser.h"

@interface PianobarControlAppDelegate : NSObject <NSApplicationDelegate> {
	PianobarControlModel *model;
	NSStatusItem *statusItem;    
    JMSongInfoParser *songInfo;

	IBOutlet NSMenu *statusMenu;
	IBOutlet NSPanel *stationSelection;
	IBOutlet NSTableView *stationsTable;
	IBOutlet NSSearchField *filterBy;
	IBOutlet NSPanel *aboutPanel;
	IBOutlet NSTextField *aboutVersion;
	IBOutlet NSTextField *aboutCopyRight;
	IBOutlet NSTextField *aboutUrl;
	IBOutlet NSMenuItem *currentSong;
}

- (void) performAction:(NSString *)action;
- (void) playStation:(NSString*)stationId;
- (void) playStationAndHideSelector:(NSString*)stationString;
- (void) raiseApplication;
- (void) setHyperlinkForTextField:(NSTextField*)aTextField url:(NSURL*)anUrl string:(NSString*)aString;

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
- (IBAction) choseStation:(id)sender;
- (IBAction) filterStations:(id)sender;
- (IBAction) showAboutPanel:(id)sender;
- (IBAction) tableViewSelected:(id)sender;
- (IBAction) doubleClicked:(id)sender;

- (void) registerKeys;

@property(nonatomic, retain) PianobarControlModel *model;
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

@property(nonatomic, retain) JMSongInfoParser *songInfo;

@end

#pragma mark C elements for Hotkey support
id refToSelf;
OSStatus myHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData);
#pragma mark -
