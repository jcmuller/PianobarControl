//
//  PianobarControlAppDelegate.h
//  PianobarControl
//
//  Created by Juan C. Müller on 3/5/11.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface PianobarControlAppDelegate : NSObject <NSApplicationDelegate> {
  IBOutlet NSMenu *statusMenu;
  NSStatusItem *statusItem;
}

- (void) performAction:(id)action;
- (void) showAboutPanel:(id)sender;
- (void) playAction:(id)sender;
- (void) nextAction:(id)sender;
- (void) loveAction:(id)sender;
- (void) banAction:(id)sender;
- (void) showInfoAction:(id)sender;
- (void) chooseStationAction:(id)sender;

- (void) registerKeys;
- (void) showMenu;

@end

void *refToSelf;
OSStatus myHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData);

