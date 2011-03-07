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
@synthesize statusItem;

@synthesize aboutPanel;
@synthesize aboutVersion;
@synthesize aboutCopyRight;
@synthesize aboutUrl;

@synthesize model;
@synthesize controller;

#pragma mark NSApplicationDelegate methods
- (void)awakeFromNib {
	refToSelf = self;
	
	model = [[PianobarControlModel alloc] init];
	controller = [[PianobarControlController alloc] init];

	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusItem setImage:[NSImage imageNamed:@"pandora-logo-16.png"]];
	[statusItem setHighlightMode:YES];
	[statusItem setMenu:statusMenu];
	[self registerKeys];
	[stationsTable setDataSource:model];
	[stationsTable setDoubleAction:@selector(doubleClicked:)];
}
#pragma mark -

#pragma mark Actions
- (IBAction) playAction:(id)sender {
	[controller performAction:@"p"];
}

- (IBAction) nextAction:(id)sender {
	[controller performAction:@"n"];
}

- (IBAction) loveAction:(id)sender {
	[controller performAction:@"+"];
}

- (IBAction) banAction:(id)sender {
	[controller performAction:@"-"];
}

- (IBAction) showInfoAction:(id)sender {
	[controller performAction:@"e"];
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

#pragma mark Utility Methods
- (void) playStationAndHideSelector:(NSString *)stationString {
	NSArray* elements = [stationString componentsSeparatedByString:@". "];
	[controller playStation:[elements objectAtIndex:0]];
	[stationSelection setIsVisible:NO];
}


- (void) raiseApplication {
	[[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
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
	[string release];
}

- (IBAction) tableViewSelected:(id)sender {
}

- (IBAction) doubleClicked:(id)sender {
	int row = [sender selectedRow];
	NSString *selected = [[model stations] objectAtIndex:row];
	[self playStationAndHideSelector:selected];
}
#pragma mark -

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

	EventTypeSpec  eventType;
	
	eventType.eventClass = kEventClassKeyboard;
	eventType.eventKind  = kEventHotKeyPressed;
	InstallApplicationEventHandler(&myHotKeyHandler, 1, &eventType, NULL, NULL);
	
	menuDisplayHotKeyID.signature = 'pbchk1';
	menuDisplayHotKeyID.id = 1;
	
	nextSongHotKeyID.signature = 'pbchk2';
	nextSongHotKeyID.id = 2;
	
	loveHotKeyID.signature = 'pbchk3';
	loveHotKeyID.id = 3;
	
	playPauseHotKeyID.signature = 'pbchk4';
	playPauseHotKeyID.id = 4;
	
	chooseStationHotKeyID.signature = 'pbchk5';
	chooseStationHotKeyID.id = 5;
	
	// Look at Events.h for the keycodes (~ line 198)
	// /Developer/SDKs/MacOSX10.6.sdk/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/Headers/Events.h
	// P
	RegisterEventHotKey(35, shiftKey+optionKey, menuDisplayHotKeyID, GetApplicationEventTarget(), 0, &menuDisplayHotKeyRef);
	// N
	RegisterEventHotKey(45, shiftKey+optionKey, nextSongHotKeyID, GetApplicationEventTarget(), 0, &nextSongHotKeyRef);
	// L
	RegisterEventHotKey(37, shiftKey+optionKey, loveHotKeyID, GetApplicationEventTarget(), 0, &loveHotKeyRef);
	// O
	RegisterEventHotKey(31, shiftKey+optionKey, playPauseHotKeyID, GetApplicationEventTarget(), 0, &playPauseHotKeyRef);
	RegisterEventHotKey(1, shiftKey+optionKey, chooseStationHotKeyID, GetApplicationEventTarget(), 0, &chooseStationHotKeyRef);
}

- (id) showMenu {
	[statusItem popUpStatusItemMenu:statusMenu];
	return nil;
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
	}

	return noErr;
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
	[model release];
	[controller release];
	[super dealloc];
}
#pragma mark -

@end

