//
//  PianobarControlAppDelegate.m
//  PianobarControl
//
//  Created by Juan C. Müller on 3/5/11.
//

#import "PianobarControlAppDelegate.h"

@implementation PianobarControlAppDelegate

- (void)awakeFromNib {
	refToSelf = self;

	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusItem setImage:[NSImage imageNamed:@"pandora-logo-16.png"]];
	[statusItem setHighlightMode:YES];
	[statusItem setMenu:statusMenu];
	[self registerKeys];
	[stationsTable setDataSource:self];
}

- (void) raiseApplication {
	[[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
}

- (void)showAboutPanel:(id)sender {
	[self raiseApplication];
	[[NSApplication sharedApplication] orderFrontStandardAboutPanel:self];
}

- (void)playAction:(id)sender {
	[self performAction:@"p"];
}

- (void)nextAction:(id)sender {
	[self performAction:@"n"];
}

- (void)loveAction:(id)sender {
	[self performAction:@"+"];
}

- (void)banAction:(id)sender {
	[self performAction:@"-"];
}

- (void)showInfoAction:(id)sender {
	[self performAction:@"e"];
}

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

- (void)chooseStationAction:(id)sender {
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

- (void) chooseStationNative:(id)sender {
	[stationSelection setIsVisible:YES];
	[self raiseApplication];
	[filterBy setStringValue:@""];

	[self getStations];
	[stationsTable reloadData];
}

- (void) choseStation:(id)sender {
	int selectedRow = [stationsTable selectedRow];
	[self getStations];
	
	if (stationsCount == 1) {
		NSString *selected = [stations objectAtIndex:0];
		[self playStationAndHideSelector:selected];
	}
	else
		if (selectedRow > -1)
		{
			NSString *selected = [stations objectAtIndex:selectedRow];
			[self playStationAndHideSelector:selected];
		}	
}

- (void) playStation:(NSString*)stationId {
	[self performAction:[NSString stringWithFormat:@"s%@\n", stationId]];
}

- (void) playStationAndHideSelector:(NSString *)stationString {
	NSArray* elements = [stationString componentsSeparatedByString:@". "];
	[self playStation:[elements objectAtIndex:0]];
	[stationSelection setIsVisible:NO];
}

- (IBAction) filterStations:(id)sender {
	[stationsTable reloadData];
}

- (void) performAction:(NSString*)action {
	NSError	 *error;	
	NSString *pianobarFifo = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), @".config/pianobar/ctl"];
	//NSLog(@"Pianobar fifo path: %@", pianobarFifo);

	if(![action writeToFile:pianobarFifo atomically:NO encoding:NSUTF8StringEncoding error:&error]) {
		NSLog(@"We have a problem: %@\r\n", [error localizedFailureReason]);
	}
}

- (void) getStations {
	NSString* stationsFromFile = [NSString stringWithContentsOfFile:@"/tmp/pianobar_stations"
														   encoding:NSUTF8StringEncoding error:nil];
	NSArray* stationsNotFiltered = [stationsFromFile componentsSeparatedByString:@"\n"];
	
	if ([[filterBy stringValue] length] > 0) {
		NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", [filterBy stringValue]];
		stations = [stationsNotFiltered filteredArrayUsingPredicate:regextest];
	}
	else {
		stations = stationsNotFiltered;
	}
	
	stationsCount = [stations count];
}


// Methods from NSTableViewDataSource protocol
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	[self getStations];
	return [stations count];
}

- (IBAction)tableViewSelected:(id)sender {
	int row = [sender selectedRow];
	[self getStations];
	NSString *selected = [stations objectAtIndex:row];
	[self playStationAndHideSelector:selected];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	// stations is getting reset for some reason!
	[self getStations];
	
	if (rowIndex > -1 && rowIndex < stationsCount)
		return [stations objectAtIndex:rowIndex];
	else 
		return nil;
}

- (void)dealloc {
	[statusMenu release];
	[stationSelection release];
	[stationsTable release];
	[stations release];
	[super dealloc];
}

@end

