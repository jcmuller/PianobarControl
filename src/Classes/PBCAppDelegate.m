//
//  PianobarControlAppDelegate.m
//  PianobarControl
//
//  Created by Juan C. Müller on 3/5/11.
//  Copyright (c) 2011 Juan C. Muller, Inc. All rights reserved.
//

#import "PBCAppDelegate.h"

static BOOL sleepEnabled;
static IOPMAssertionID sleepAssertionID;

@interface PBCAppDelegate()

- (void) performAction:(NSString *)action;
- (void) playStation:(NSString*)stationId;
- (void) playStationAndHideSelector:(NSString*)stationString;
- (void) raiseApplication;
- (void) setHyperlinkForTextField:(NSTextField*)aTextField
							  url:(NSURL*)anUrl
						   string:(NSString*)aString;

- (void) setCurrentSongTitle:(id)sender;
- (id) showMenu;
- (void) registerKeys;
- (void) alternateIcon;
- (void) resetIcon:(id)sender;
- (void) doubleClicked:(id)sender;

@end

@implementation PBCAppDelegate

#pragma mark Attributes

@synthesize model = _model;
@synthesize statusItem = _statusItem;
@synthesize songInfo = _songInfo;

@synthesize statusMenu = _statusMenu;
@synthesize currentSong = _currentSong;
@synthesize sleepDisabledMenuItem = _sleepDisabledMenuItem;

@synthesize stationSelection = _stationSelection;
@synthesize stationsTable = _stationsTable;
@synthesize filterBy = _filterBy;

@synthesize aboutPanel = _aboutPanel;
@synthesize aboutVersion = _aboutVersion;
@synthesize aboutCopyRight = _aboutCopyRight;
@synthesize aboutUrl = _aboutUrl;

#pragma mark -

#pragma mark NSApplicationDelegate methods

- (void) awakeFromNib
{
	[self setModel:[[[PBCModel alloc] init] autorelease]];

	[NSApp setDelegate:self];

	NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[statusItem setImage:[NSImage imageNamed:@"pandora-logo-16_gray.png"]];
	[statusItem setAlternateImage:[NSImage imageNamed:@"pandora-logo-16.png"]];
	[statusItem setHighlightMode:YES];

	[statusItem setMenu:[self statusMenu]];
	[self setStatusItem:statusItem];

	[[self stationsTable] setDoubleAction:@selector(doubleClicked:)];

	[[self stationsTable] setDataSource:[self model]];
	refToSelf = self;

	[self registerKeys];

	[self setCurrentSongTitle:nil];

	// UGLY
	[NSTimer scheduledTimerWithTimeInterval:2.0
									 target:self
								   selector:@selector(setCurrentSongTitle:)
								   userInfo:nil
									repeats:YES];

	[self setSongInfo:[[[PBCSongInfoParser alloc] init] autorelease]];
	
	sleepAssertionID = -1;
	sleepEnabled = YES;
}
#pragma mark -

#pragma mark Actions
- (IBAction) playAction:(id)sender
{
	[self performAction:@"p"];
}

- (IBAction) nextAction:(id)sender
{
	[self performAction:@"n"];
}

- (IBAction) loveAction:(id)sender
{
	[self performAction:@"+"];
}

- (IBAction) banAction:(id)sender
{
	[self performAction:@"-"];
}

- (IBAction) showInfoAction:(id)sender
{
	[self performAction:@"e"];
	[self setCurrentSongTitle:nil];
}

- (IBAction) showLyricsAction:(id)sender
{
	[self alternateIcon];
	[[NSWorkspace sharedWorkspace] openURL:[[self songInfo] searchLyricsURL]];
}

- (void) setCurrentSongTitle:(id)sender
{
	[[self songInfo] parse];
	if ([[self songInfo] currentSongString] != nil)
		[[self currentSong] setTitle:[[self songInfo] currentSongString]];
}

- (IBAction) chooseStationAction:(id)sender
{
	[self alternateIcon];

	if (![[self stationSelection] isVisible])
	{
		// Reset filter
		[[self filterBy] setStringValue:@""];

		// Set focus to filter
		[[self filterBy] becomeFirstResponder];

		// Disable saving searches
		[[self filterBy] setRecentsAutosaveName:nil];

		// Load data
		[[self model] loadStations:[[self filterBy] stringValue]];

		// Mark table as needing update
		[[self stationsTable] reloadData];

		// Select first row or playing station
		if ([[self model] stationPlaying] != nil)
		{
			[[self stationsTable] selectRowIndexes:[NSIndexSet indexSetWithIndex:[[[self model] stationPlaying] intValue]] byExtendingSelection:NO];
			// Scroll to station
			[[self stationsTable] scrollRowToVisible:[[[self model] stationPlaying] intValue]];
		}
		else
		{
			[[self stationsTable] selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
			// Scroll to top
			[[self stationsTable] scrollRowToVisible:0];
		}

		// Restore the default size of the window
		[[self stationSelection] setFrame:NSMakeRect(1, 1, 350, 700) display:NO animate:NO];

		[[self stationSelection] setMovableByWindowBackground:YES];
		[[self stationSelection] setMovable:YES];
		[[self stationSelection] setHasShadow:YES];

		// Position it nicely and display it
		[[self stationSelection] center];
		[[self stationSelection] setIsVisible:YES];
	}

	// Bring to front
	[[self stationSelection] makeKeyAndOrderFront:nil];

	// Bring application forward
	[self raiseApplication];
}

- (IBAction) choseStation:(id)sender {
	int selectedRow = [[self stationsTable] selectedRow];

	// If there is just one station in the search box, select it
	if ([[self stationsTable] numberOfRows] == 1)
		[[self stationsTable] selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];

	// Sanity check...
	if (selectedRow > -1)
	{
		NSString *selected = [[[self model] stations] objectAtIndex:selectedRow];
		[self playStationAndHideSelector:selected];
	}
}

- (IBAction) filterStations:(id)sender {
	// Load data
	[[self model] loadStations:[[self filterBy] stringValue]];

	// Mark table as needing update
	[[self stationsTable] reloadData];

	// Select first result if nothing is selected
	if ([[self stationsTable] selectedRow] < 0)
		[[self stationsTable] selectRowIndexes:[NSIndexSet indexSetWithIndex:0]
				   byExtendingSelection:NO];
}

- (IBAction) showAboutPanel:(id)sender
{
	if (![[self aboutPanel] isVisible])
	{
		[[self aboutCopyRight] setStringValue:[NSString stringWithFormat:
			@"Copyright %@", [[[NSBundle mainBundle] infoDictionary]
			objectForKey:@"NSHumanReadableCopyright"]]];
		[[self aboutVersion] setStringValue:[NSString stringWithFormat:
			@"Version %@", [[[NSBundle mainBundle] infoDictionary]
			objectForKey:@"CFBundleVersion"]]];

		NSString *urlString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleGetInfoString"];
		NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

		NSLog(@"urlString: %@ url: %@", urlString, url);
		[self setHyperlinkForTextField:[self aboutUrl] url:url string:(NSString*)urlString];

		// Position it nicely and display it
		[[self aboutPanel] center];
		[[self aboutPanel] setIsVisible:YES];
	}

	// Bring to front
	[[self aboutPanel] makeKeyAndOrderFront:nil];

	// Bring application forward
	[self raiseApplication];
}

- (IBAction) toggleSleepAllow:(id)sender
{
	if (sleepEnabled)
	{
		IOReturn success = IOPMAssertionCreateWithName(
													   kIOPMAssertionTypeNoDisplaySleep,
													   kIOPMAssertionLevelOn,
													   (CFStringRef)@"Don't wake me",
													   &sleepAssertionID);
		
		if (success == kIOReturnSuccess)
		{
			NSLog(@"Disabling sleep...");
			sleepEnabled = NO;
			[[self sleepDisabledMenuItem] setState:NSOnState];
		}
	}
	else
	{
		IOReturn success = IOPMAssertionRelease(sleepAssertionID);
		
		if (success == kIOReturnSuccess)
		{
			NSLog(@"Enabling sleep...");
			sleepEnabled = YES;
			[[self sleepDisabledMenuItem] setState:NSOffState];
		}
	}
}

#pragma mark -

#pragma mark Arrow Key support in search box

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command
{
	NSLog(@"command:%s", (char*)command);

	NSInteger currentRow = [[self stationsTable] selectedRow];

	if (command == @selector(moveDown:))
		currentRow++;
	else if (command == @selector(moveUp:))
		currentRow--;
	else if (command == @selector(scrollPageUp:))
		currentRow -= 15;
	else if (command == @selector(scrollPageDown:))
		currentRow += 15;
	else
		return NO;

	if (currentRow >= [[self stationsTable] numberOfRows])
		currentRow = [[self stationsTable] numberOfRows] - 1;
	if (currentRow < 0)
		currentRow = 0;

	[[self stationsTable] selectRowIndexes:[NSIndexSet indexSetWithIndex:currentRow] byExtendingSelection:NO];
	[[self stationsTable] scrollRowToVisible:currentRow];

	return YES;
}

#pragma mark -

#pragma mark Utility Methods
- (void) playStationAndHideSelector:(NSString *)stationString
{
	NSArray* elements = [stationString componentsSeparatedByString:@". "];
	[self playStation:[elements objectAtIndex:0]];
	[[self stationSelection] setIsVisible:NO];
}

- (id) showMenu
{
	[[self statusItem] popUpStatusItemMenu:[self statusMenu]];
	return nil;
}

- (void) raiseApplication
{
	[[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
}

- (void) performAction:(NSString*)action
{
	[self alternateIcon];
	
	NSError	 *error;
	NSString *pianobarFifo = [NSHomeDirectory() stringByAppendingPathComponent:@".config/pianobar/ctl"];
	NSLog(@"Pianobar fifo path: %@ action: %@", pianobarFifo, action);

	if (![action writeToFile:pianobarFifo
				  atomically:NO
					encoding:NSUTF8StringEncoding
					   error:&error])
		NSLog(@"We have a problem: %@\r\n", [error localizedFailureReason]);
}

- (void) playStation:(NSString*)stationId
{
	[self performAction:[NSString stringWithFormat:@"s%@\n", stationId]];
}

- (void) setHyperlinkForTextField:(NSTextField*)aTextField url:(NSURL*)anUrl string:(NSString*)aString
{
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
#pragma mark -

#pragma mark Methods for NSTableView
- (IBAction) tableViewSelected:(id)sender
{
}

- (void) doubleClicked:(id)sender
{
	int row = [sender selectedRow];
	NSString *selected = [[[self model] stations] objectAtIndex:row];
	[self playStationAndHideSelector:selected];
}
#pragma mark -

- (void) alternateIcon
{
	[[self statusItem] setImage:[NSImage imageNamed:@"pandora-logo-16.png"]];
	
	[NSTimer scheduledTimerWithTimeInterval:0.2
									 target:self
								   selector:@selector(resetIcon:)
								   userInfo:nil
									repeats:NO];
}

- (void) resetIcon:(id)sender
{
	[[self statusItem] setImage:[NSImage imageNamed:@"pandora-logo-16_gray.png"]];
}

#pragma mark Hotkeys
- (void) registerKeys
{
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

	EventHotKeyRef songLyricsHotKeyRef;
	EventHotKeyID  songLyricsHotKeyID;

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

	songLyricsHotKeyID.signature = 'phk9';
	songLyricsHotKeyID.id = 9;


	// Look at Events.h for the keycodes (~ line 198)
	// /Developer/SDKs/MacOSX10.6.sdk/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/Headers/Events.h
	// P
	RegisterEventHotKey(0x23, shiftKey+optionKey, menuDisplayHotKeyID,
			GetApplicationEventTarget(), 0, &menuDisplayHotKeyRef);
	// N
	RegisterEventHotKey(0x2D, shiftKey+optionKey, nextSongHotKeyID,
			GetApplicationEventTarget(), 0, &nextSongHotKeyRef);
	// L
	RegisterEventHotKey(0x25, shiftKey+optionKey, loveHotKeyID,
			GetApplicationEventTarget(), 0, &loveHotKeyRef);
	// O
	RegisterEventHotKey(0x1F, shiftKey+optionKey, playPauseHotKeyID,
			GetApplicationEventTarget(), 0, &playPauseHotKeyRef);
	// S
	RegisterEventHotKey(0x01, shiftKey+optionKey, chooseStationHotKeyID,
			GetApplicationEventTarget(), 0, &chooseStationHotKeyRef);
	// B
	RegisterEventHotKey(0x0B, shiftKey+optionKey, banHotKeyID,
			GetApplicationEventTarget(), 0, &banHotKeyRef);
	// I
	RegisterEventHotKey(0x22, shiftKey+optionKey, songInfoHotKeyID,
			GetApplicationEventTarget(), 0, &songInfoHotKeyRef);
	// Q
	RegisterEventHotKey(0x0C, shiftKey+optionKey, quitHotKeyID,
			GetApplicationEventTarget(), 0, &quitHotKeyRef);
	// Y
	RegisterEventHotKey(0x10, shiftKey+optionKey, songLyricsHotKeyID,
			GetApplicationEventTarget(), 0, &songLyricsHotKeyRef);
}

OSStatus myHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData)
{
	EventHotKeyID hkRef;
	GetEventParameter(anEvent, kEventParamDirectObject, typeEventHotKeyID,
			NULL, sizeof(hkRef), NULL, &hkRef);

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
		case 9:
			[refToSelf showLyricsAction:nil];
			break;
	}

	return noErr;
}
#pragma mark -

#pragma mark NSObject
- (void)dealloc
{
	[_aboutPanel release];
	[_aboutVersion release];
	[_aboutCopyRight release];
	[_aboutUrl release];
	[_currentSong release];
	[_filterBy release];
	[_sleepDisabledMenuItem release];
	[_songInfo release];
	[_stationSelection release];
	[_stationsTable release];
	[_statusItem release];
	[_statusMenu release];
	[_model release];
	[super dealloc];
}
#pragma mark -

@end

