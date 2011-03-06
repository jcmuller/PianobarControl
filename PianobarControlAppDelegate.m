//
//  PianobarControlAppDelegate.m
//  PianobarControl
//
//  Created by Juan C. Müller on 3/5/11.
//

#import "PianobarControlAppDelegate.h"
#import "NSAttributedString+Hyperlink.h"

@implementation PianobarControlAppDelegate

@synthesize statusMenu;

@synthesize stationSelection;
@synthesize stationsTable;
@synthesize filterBy;
@synthesize stations;
@synthesize statusItem;

@synthesize aboutPanel;
@synthesize aboutVersion;
@synthesize aboutCopyRight;
@synthesize aboutUrl;

#pragma mark NSApplicationDelegate methods
- (void)awakeFromNib {
	refToSelf = self;

	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusItem setImage:[NSImage imageNamed:@"pandora-logo-16.png"]];
	[statusItem setHighlightMode:YES];
	[statusItem setMenu:statusMenu];
	[self registerKeys];
	[stationsTable setDataSource:self];
	[stationsTable setDoubleAction:@selector(doubleClicked:)];
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
	[self refreshTableData];

	// Restore the default size of the window
	NSRect newFrame = NSMakeRect(1, 1, 450, 500);
	[stationSelection setFrame:newFrame display:NO animate:NO];
	

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

- (IBAction) filterStations:(id)sender {
	[self refreshTableData];
}

- (IBAction) showAboutPanel:(id)sender {
//	[[NSApplication sharedApplication] orderFrontStandardAboutPanel:self];

	[aboutCopyRight setStringValue:[NSString stringWithFormat:@"Copyright %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"NSHumanReadableCopyright"]]];
	[aboutVersion setStringValue:[NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
	//[aboutUrl setStringValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleGetInfoString"]];

	NSString *urlString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleGetInfoString"];
	NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

	NSLog(@"urlString: %@ url: %@", urlString, url);
	[self setHyperlinkForTextField:aboutUrl url:url string:(NSString*)urlString];
	
	// Position it nicely and display it
	[aboutPanel center];
	[aboutPanel setIsVisible:YES];
	
	// Bring application forward
	[self raiseApplication];	
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
	
	if ([[filterBy stringValue] isEqual:@""])
		[self setStations:stationsNotFiltered];
	else {
		NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", [filterBy stringValue]];
		[self setStations:[stationsNotFiltered filteredArrayUsingPredicate:regextest]];
	}

	stationsCount = [stations count];
}

- (void) refreshTableData {
	// Refresh stations
	[self getStations];
	[stationsTable reloadData];
	
	// Select first row
	[stationsTable selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
	// Scroll to top
	[stationsTable scrollRowToVisible:0];	
}

- (void) setHyperlinkForTextField:(NSTextField*)aTextField url:(NSURL*)anUrl string:(NSString*)aString {
    // both are needed, otherwise hyperlink won't accept mousedown
    [aTextField setAllowsEditingTextAttributes: YES];
    [aTextField setSelectable: YES];
	[aTextField setAlignment:NSCenterTextAlignment];
		
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] init];
    [string appendAttributedString: [NSAttributedString hyperlinkFromString:aString withURL:anUrl]];
	
    // set the attributed string to the NSTextField
    [aTextField setAttributedStringValue: string];
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

#pragma mark C elements for Hotkey support
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

- (IBAction) tableViewSelected:(id)sender {
}

- (IBAction) doubleClicked:(id)sender {
	int row = [sender selectedRow];
	NSString *selected = [stations objectAtIndex:row];
	[self playStationAndHideSelector:selected];
}
#pragma mark -

#pragma mark destructor
- (void)dealloc {
	[aboutVersion release];
	[aboutCopyRight release];
	[aboutUrl release];
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

