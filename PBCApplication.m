//
//  JCMApplication.m
//  PianobarControl
//
//  Created by Juan C. Muller on 11/25/11.
//  Copyright (c) 2011 Juan C. Muller, Inc. All rights reserved.
//
//  From http://rogueamoeba.com/utm/archives/MediaKeys.m
//

#import "PBCApplication.h"

@implementation PBCApplication

- (void)mediaKeyEvent:(int)key state:(BOOL)state repeat:(BOOL)repeat
{    
    if (state == 0)
    {
        switch(key)
        {
            case NX_KEYTYPE_PLAY:
                [_delegate performSelector:@selector(playAction:)];
                break;
            case NX_KEYTYPE_FAST:
                [_delegate performSelector:@selector(nextAction:)];
                break;            
            case NX_KEYTYPE_REWIND:
                [_delegate performSelector:@selector(showInfoAction:)];
                break;
        }
    }
}

- (void)sendEvent:(NSEvent*)event
{
	if( [event type] == NSSystemDefined && [event subtype] == 8 )
	{
		int keyCode   = (([event data1] & 0xFFFF0000) >> 16);
		int keyFlags  = ([event data1] & 0x0000FFFF);
		int keyState  = (((keyFlags & 0xFF00) >> 8)) == 0xA;
		int keyRepeat = (keyFlags & 0x1);
		
		[self mediaKeyEvent:keyCode state:keyState repeat:keyRepeat];
	}
    
	[super sendEvent: event];
}

@end
