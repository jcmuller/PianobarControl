//
//  PianobarControlController.m
//  PianobarControl
//
//  Created by Juan C. Müller on 3/7/11.
//  Copyright 2011 Challenge Post. All rights reserved.
//

#import "PianobarControlController.h"

@implementation PianobarControlController

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

@end
