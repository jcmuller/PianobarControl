//
//  PianobarControlAppDelegate.m
//  PianobarControl
//
//  Created by Juan C. Müller on 3/5/11.
//

#import "PianobarControlAppDelegate.h"

@implementation PianobarControlAppDelegate

@synthesize model;

@synthesize statusMenu;

@synthesize stationSelection;
@synthesize stationsTable;
@synthesize filterBy;
@synthesize statusItem;

@synthesize aboutPanel;
@synthesize aboutVersion;
@synthesize aboutCopyRight;
@synthesize aboutUrl;

#pragma mark NSApplicationDelegate methods
- (void)awakeFromNib {
	model = [[PianobarControlModel alloc] init];

	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusItem setImage:[NSImage imageNamed:@"pandora-logo-16.png"]];
	[statusItem setHighlightMode:YES];
	[statusItem setMenu:statusMenu];
	[stationsTable setDoubleAction:@selector(doubleClicked:)];

	[stationsTable setDataSource:model];
	refToSelf = self;

	[self registerKeys];
}
#pragma mark -

- (void) performAction:(NSString*)action {
	NSError	 *error;
	NSString *pianobarFifo = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), @".config/pianobar/ctl"];
	NSLog(@"Pianobar fifo path: %@ action: %@", pianobarFifo, action);

	if(![action writeToFile:pianobarFifo atomically:NO encoding:NSUTF8StringEncoding error:&error]) {
		NSLog(@"We have a problem: %@\r\n", [error localizedFailureReason]);
	}
}

- (void) playStation:(NSString*)stationId {
	[self performAction:[NSString stringWithFormat:@"s%@\n", stationId]];
}

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
	// Reset filter
	[filterBy setStringValue:@""];

	// Set focus to filter
	[filterBy becomeFirstResponder];

	// Load data
	[model loadStations:[filterBy stringValue]];

	// Mark table as needing update
	[stationsTable reloadData];

	// Select first row
	[stationsTable selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
	// Scroll to top
	[stationsTable scrollRowToVisible:0];

	// Restore the default size of the window
	NSRect newFrame = NSMakeRect(1, 1, 450, 500);
	[stationSelection setFrame:newFrame display:NO animate:NO];


	// Position it nicely and display it
	[stationSelection center];
	[stationSelection setIsVisible:YES];

	// Bring to front
	[stationSelection makeKeyAndOrderFront:nil];

	// Bring application forward
	[self raiseApplication];
}

- (IBAction) choseStation:(id)sender {
	int selectedRow = [stationsTable selectedRow];

	// Sanity check...
	if (selectedRow > -1)
	{
		NSString *selected = [[model stations] objectAtIndex:selectedRow];
		[self playStationAndHideSelector:selected];
	}
}

#pragma mark Utility Methods
- (void) playStationAndHideSelector:(NSString *)stationString {
	NSArray* elements = [stationString componentsSeparatedByString:@". "];
	[self playStation:[elements objectAtIndex:0]];
	[stationSelection setIsVisible:NO];
}

- (id) showMenu {
	[statusItem popUpStatusItemMenu:statusMenu];
	return nil;
}

- (void) raiseApplication {
	[[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
}

- (IBAction) filterStations:(id)sender {
	// Load data
	[model loadStations:[filterBy stringValue]];
	// Mark table as needing update
	[stationsTable reloadData];
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

	// Bring to front
	[aboutPanel makeKeyAndOrderFront:nil];

	// Bring application forward
	[self raiseApplication];
}
#pragma mark -

- (void) setHyperlinkForTextField:(NSTextField*)aTextField url:(NSURL*)anUrl string:(NSString*)aString {
	// both are needed, otherwise hyperlink won't accept mousedown
	[aTextField setAllowsEditingTextAttributes: YES];
	[aTextField setSelectable: YES];
	[aTextField setAlignment:NSCenterTextAlignment];

	NSMutableAttributedString* string = [[NSMutableAttributedString alloc] init];
	[string appendAttributedString: [NSAttributedString hyperlinkFromString:aString withURL:anUrl]];

	// set the attributed string to the NSTextField
	[aTextField setAttributedStringValue: string];
	[string release];
}

- (IBAction) tableViewSelected:(id)sender {
}

- (IBAction) doubleClicked:(id)sender {
	int row = [sender selectedRow];
	NSString *selected = [[model stations] objectAtIndex:row];
	[self playStationAndHideSelector:selected];
}

#pragma mark Hotkeys
- (void) registerKeys {
	EventHotKeyRef menuDisplayHotKeyRef;
	EventHotKeyID  menuDisplayHotKeyID;

	EventHotKeyRef nextSongHotKeyRef;
	EventHotKeyID  nextSongHotKeyID;

	EventHotKeyRef loveHotKeyRef;
	EventHotKeyID  loveHotKeyID;

	EventHotKeyRef playPauseHotKeyRef;
	EventHotKeyID  playPauseHotKeyID;

	EventHotKeyRef chooseStationHotKeyRef;
	EventHotKeyID  chooseStationHotKeyID;

	EventHotKeyRef banHotKeyRef;
	EventHotKeyID  banHotKeyID;

	EventHotKeyRef songInfoHotKeyRef;
	EventHotKeyID  songInfoHotKeyID;

	EventHotKeyRef quitHotKeyRef;
	EventHotKeyID  quitHotKeyID;

	EventTypeSpec  eventType;

	eventType.eventClass = kEventClassKeyboard;
	eventType.eventKind  = kEventHotKeyPressed;
	InstallApplicationEventHandler(&myHotKeyHandler, 1, &eventType, NULL, NULL);

	menuDisplayHotKeyID.signature = 'phk1';
	menuDisplayHotKeyID.id = 1;

	nextSongHotKeyID.signature = 'phk2';
	nextSongHotKeyID.id = 2;

	loveHotKeyID.signature = 'phk3';
	loveHotKeyID.id = 3;

	playPauseHotKeyID.signature = 'phk4';
	playPauseHotKeyID.id = 4;

	chooseStationHotKeyID.signature = 'phk5';
	chooseStationHotKeyID.id = 5;

	banHotKeyID.signature = 'phk6';
	banHotKeyID.id = 6;

	songInfoHotKeyID.signature = 'phk7';
	songInfoHotKeyID.id = 7;

	quitHotKeyID.signature = 'phk8';
	quitHotKeyID.id = 8;

	// Look at Events.h for the keycodes (~ line 198)
	// /Developer/SDKs/MacOSX10.6.sdk/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/Headers/Events.h
	// P
	RegisterEventHotKey(0x23, shiftKey+optionKey, menuDisplayHotKeyID,   GetApplicationEventTarget(), 0, &menuDisplayHotKeyRef);
	// N
	RegisterEventHotKey(0x2D, shiftKey+optionKey, nextSongHotKeyID,      GetApplicationEventTarget(), 0, &nextSongHotKeyRef);
	// L
	RegisterEventHotKey(0x25, shiftKey+optionKey, loveHotKeyID,          GetApplicationEventTarget(), 0, &loveHotKeyRef);
	// O
	RegisterEventHotKey(0x1F, shiftKey+optionKey, playPauseHotKeyID,     GetApplicationEventTarget(), 0, &playPauseHotKeyRef);
	// S
	RegisterEventHotKey(0x01, shiftKey+optionKey, chooseStationHotKeyID, GetApplicationEventTarget(), 0, &chooseStationHotKeyRef);
	// B
	RegisterEventHotKey(0x0B, shiftKey+optionKey, banHotKeyID,           GetApplicationEventTarget(), 0, &banHotKeyRef);
	// I
	RegisterEventHotKey(0x22, shiftKey+optionKey, songInfoHotKeyID,      GetApplicationEventTarget(), 0, &songInfoHotKeyRef);
	// Q
	RegisterEventHotKey(0x0C, shiftKey+optionKey, quitHotKeyID,          GetApplicationEventTarget(), 0, &quitHotKeyRef);
}

#pragma mark C elements for Hotkey support
OSStatus myHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData) {
	EventHotKeyID hkRef;
	GetEventParameter(anEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hkRef), NULL, &hkRef);

	switch (hkRef.id) {
		case 1:
			[refToSelf showMenu];
			break;
		case 2:
			[refToSelf nextAction:nil];
			break;
		case 3:
			[refToSelf loveAction:nil];
			break;
		case 4:
			[refToSelf playAction:nil];
			break;
		case 5:
			[refToSelf chooseStationAction:nil];
			break;
		case 6:
			[refToSelf banAction:nil];
			break;
		case 7:
			[refToSelf showInfoAction:nil];
			break;
		case 8:
			exit(0);
			break;
	}

	return noErr;
}
#pragma mark -


- (void)dealloc {
	[aboutVersion release];
	[aboutCopyRight release];
	[aboutUrl release];
	[statusItem release];
	[statusMenu release];
	[stationSelection release];
	[stationsTable release];
	[filterBy release];
	[model release];
	[super dealloc];
}

@end

