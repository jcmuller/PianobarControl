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

	NSArray *stations;
	NSInteger stationsCount;

	NSStatusItem *statusItem;
}

- (void) performAction:(NSString *)action;

- (void) playAction:(id)sender;
- (void) nextAction:(id)sender;
- (void) loveAction:(id)sender;
- (void) banAction:(id)sender;
- (void) showInfoAction:(id)sender;
- (void) chooseStationAction:(id)sender;

- (void) playStation:(NSString*)stationId;
- (void) playStationAndHideSelector:(NSString*)stationString;

- (void) raiseApplication;

- (void) showAboutPanel:(id)sender;

- (void) chooseStationNative:(id)sender;
- (void) choseStation:(id)sender;
- (IBAction) tableViewSelected:(id)sender;
- (IBAction) filterStations:(id)sender;

- (void) getStations;

- (void) registerKeys;
- (void) showMenu;

@end

void *refToSelf;
OSStatus myHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData);

