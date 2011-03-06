//
//  PianobarControlAppDelegate.m
//  PianobarControl
//
//  Created by Juan C. Müller on 3/5/11.
//

#import "PianobarControlAppDelegate.h"

@implementation PianobarControlAppDelegate

@synthesize statusMenu;
@synthesize stationSelection;
@synthesize stationsTable;
@synthesize filterBy;
@synthesize stations;
@synthesize statusItem;

#pragma mark NSApplicationDelegate methods
- (void)awakeFromNib {
	refToSelf = self;

	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusItem setImage:[NSImage imageNamed:@"pandora-logo-16.png"]];
	[statusItem setHighlightMode:YES];
	[statusItem setMenu:statusMenu];
	[self registerKeys];
	[stationsTable setDataSource:self];
}
#pragma mark -

#pragma mark Actions
- (IBAction) playAction:(id)sender {
	[self performAction:@"p"];
}

- (IBAction) nextAction:(id)sender {
	[self performAction:@"n"];
}

- (IBAction) loveAction:(id)sender {
	[self performAction:@"+"];
}

- (IBAction) banAction:(id)sender {
	[self performAction:@"-"];
}

- (IBAction) showInfoAction:(id)sender {
	[self performAction:@"e"];
}

- (IBAction) chooseStationAction:(id)sender {
	// Execute script
	NSString *pianobarChooseStationScript = [NSString stringWithFormat:@"%@/%@ &",
											 [[NSBundle mainBundle] bundlePath], @"Contents/Resources/pianobar-choose-station"];
	NSLog(@"Pianobar choose station script file path: %@", pianobarChooseStationScript);
	
	system([pianobarChooseStationScript UTF8String]);
	
	// Force X11 to come up front.
	NSArray *apps;
	apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"org.x.X11"];
	[[apps objectAtIndex:0] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
}

- (IBAction) chooseStationNative:(id)sender {
	// Reset filter
	[filterBy setStringValue:@""];
	
	// Set focus to filter
	[filterBy becomeFirstResponder];
	
	// Load data
	[self getStations];
	[stationsTable reloadData];
	
	// Select first row
	[stationsTable selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
	
	// Restore the default size of the window
	NSRect newFrame = NSMakeRect(1, 1, 450, 500);
	[stationSelection setFrame:newFrame display:NO animate:NO];
	
	// Scroll to top
	[stationsTable scrollRowToVisible:0];
	
	// Position it nicely and display it
	[stationSelection center];
	[stationSelection setIsVisible:YES];
	
	// Bring application forward
	[self raiseApplication];
}

- (IBAction) choseStation:(id)sender {
	int selectedRow = [stationsTable selectedRow];
	
	// Sanity check...
	if (selectedRow > -1)
	{
		NSString *selected = [stations objectAtIndex:selectedRow];
		[self playStationAndHideSelector:selected];
	}	
}

- (IBAction) tableViewSelected:(id)sender {
	int row = [sender selectedRow];
	NSString *selected = [stations objectAtIndex:row];
	[self playStationAndHideSelector:selected];
}

- (IBAction) filterStations:(id)sender {
	[self getStations];
	[stationsTable reloadData];
}

- (IBAction) showAboutPanel:(id)sender {
	[self raiseApplication];
	[[NSApplication sharedApplication] orderFrontStandardAboutPanel:self];
}
#pragma mark -

#pragma mark Utility Methods
- (void) playStation:(NSString*)stationId {
	[self performAction:[NSString stringWithFormat:@"s%@\n", stationId]];
}

- (void) playStationAndHideSelector:(NSString *)stationString {
	NSArray* elements = [stationString componentsSeparatedByString:@". "];
	[self playStation:[elements objectAtIndex:0]];
	[stationSelection setIsVisible:NO];
}

- (void) performAction:(NSString*)action {
	NSError	 *error;	
	NSString *pianobarFifo = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), @".config/pianobar/ctl"];
	//NSLog(@"Pianobar fifo path: %@", pianobarFifo);
	
	if(![action writeToFile:pianobarFifo atomically:NO encoding:NSUTF8StringEncoding error:&error]) {
		NSLog(@"We have a problem: %@\r\n", [error localizedFailureReason]);
	}
}

- (void) raiseApplication {
	[[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
}

- (void) getStations {
	NSString* stationsFromFile = [NSString stringWithContentsOfFile:@"/tmp/pianobar_stations" encoding:NSUTF8StringEncoding error:nil];
	NSArray* stationsNotFiltered = [stationsFromFile componentsSeparatedByString:@"\n"];
	
	if ([[filterBy stringValue] length] > 0) {
		NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", [filterBy stringValue]];
		[self setStations:[stationsNotFiltered filteredArrayUsingPredicate:regextest]];
	}
	else {
		[self setStations:stationsNotFiltered];
	}

	stationsCount = [stations count];
}
#pragma mark -

#pragma mark Hotkeys
- (void) registerKeys {
	EventHotKeyRef myHotKeyRef;
	EventHotKeyID  myHotKeyID;
	EventTypeSpec  eventType;
	
	eventType.eventClass = kEventClassKeyboard;
	eventType.eventKind  = kEventHotKeyPressed;
	InstallApplicationEventHandler(&myHotKeyHandler, 1, &eventType, NULL, NULL);
	
	myHotKeyID.signature='mhk1';
	myHotKeyID.id=1;
	
	RegisterEventHotKey(35, shiftKey+optionKey, myHotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef);
}

- (void) showMenu {
	[statusItem popUpStatusItemMenu:statusMenu];
}
#pragma mark -

#pragma mark C-functions for Hotkey support
OSStatus myHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData) {
	EventHotKeyID hkRef;
	GetEventParameter(anEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hkRef), NULL, &hkRef);

	switch (hkRef.id) {
		case 1:
			[refToSelf showMenu];
			break;
	}

	return noErr;
}
#pragma mark -

#pragma mark NSTableViewDataSource protocol methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [stations count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	if (rowIndex > -1 && rowIndex < stationsCount)
		return [stations objectAtIndex:rowIndex];
	else 
		return nil;
}
#pragma mark -

#pragma mark destructor
- (void)dealloc {
	[statusItem release];
	[statusMenu release];
	[stationSelection release];
	[stationsTable release];
	[filterBy release];
	[stations release];
	[super dealloc];
}
#pragma mark -

@end

