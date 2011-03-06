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
}

- (void)showAboutPanel:(id)sender {
	[[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
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
	NSString *pianobarChooseStationScript = [NSString stringWithFormat:@"%@/%@ &", [[NSBundle mainBundle] bundlePath], @"Contents/Resources/pianobar-choose-station"];
	NSLog(@"Pianobar choose station script file path: %@", pianobarChooseStationScript);

	system([pianobarChooseStationScript UTF8String]);

	// Force X11 to come up front.
	NSArray *apps;
	apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"org.x.X11"];
	[[apps objectAtIndex:0] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
}

- (void)performAction:(NSString*)action {
	NSError	 *error;	
	NSString *pianobarFifo = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), @".config/pianobar/ctl"];
	//NSLog(@"Pianobar fifo path: %@", pianobarFifo);

	if(![action writeToFile:pianobarFifo atomically:NO encoding:NSUTF8StringEncoding error:&error]) {
		NSLog(@"We have a problem: %@\r\n", [error localizedFailureReason]);
	}
}

@end

