//
//  PianobarControlAppDelegate.h
//  PianobarControl
//
//  Created by Juan C. Müller on 3/5/11.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface PianobarControlAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource> {
	IBOutlet NSMenu *statusMenu;
	
	IBOutlet NSPanel *stationSelection;
	IBOutlet NSTableView *stationsTable;
	IBOutlet NSSearchField *filterBy;
	
	IBOutlet NSPanel *aboutPanel;
	IBOutlet NSTextField *aboutVersion;
	IBOutlet NSTextField *aboutCopyRight;
	IBOutlet NSTextField *aboutUrl;

	NSArray *stations;
	NSInteger stationsCount;

	NSStatusItem *statusItem;
}

#pragma mark Actions
- (IBAction) playAction:(id)sender;
- (IBAction) nextAction:(id)sender;
- (IBAction) loveAction:(id)sender;
- (IBAction) banAction:(id)sender;
- (IBAction) showInfoAction:(id)sender;
- (IBAction) chooseStationAction:(id)sender;
- (IBAction) chooseStationNative:(id)sender;
- (IBAction) choseStation:(id)sender;
- (IBAction) filterStations:(id)sender;
- (IBAction) showAboutPanel:(id)sender;
#pragma mark -

#pragma mark Utility Methods
- (void) performAction:(NSString *)action;
- (void) playStation:(NSString*)stationId;
- (void) playStationAndHideSelector:(NSString*)stationString;
- (void) raiseApplication;
- (void) getStations;
- (void) refreshTableData;
- (void) setHyperlinkForTextField:(NSTextField*)aTextField url:(NSURL*)anUrl string:(NSString*)aString;
#pragma mark -

#pragma mark Hotkeys
- (void) registerKeys;
- (void) showMenu;
#pragma mark -

#pragma mark NSTableViewDataSource delegate methods....
// for some reason, we have to mark 'em actions...
- (IBAction) tableViewSelected:(id)sender;
#pragma mark -

#pragma mark properties
@property(nonatomic, retain) NSMenu *statusMenu;
@property(nonatomic, retain) NSPanel *stationSelection;
@property(nonatomic, retain) NSTableView *stationsTable;
@property(nonatomic, retain) NSSearchField *filterBy;
@property(nonatomic, retain) NSArray *stations;
@property(nonatomic, retain) NSStatusItem *statusItem;

@property(nonatomic, retain) NSPanel *aboutPanel;
@property(nonatomic, retain) NSTextField *aboutVersion;
@property(nonatomic, retain) NSTextField *aboutCopyRight;
@property(nonatomic, retain) NSTextField *aboutUrl;
#pragma mark -

@end

#pragma mark C elements for Hotkey support
void *refToSelf;
OSStatus myHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData);
#pragma mark -
