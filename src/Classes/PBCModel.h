//
//  PianobarControlModel.h
//  PianobarControl
//
//  Created by Juan C. Müller on 3/7/11.
//  Copyright (c) 2011 Juan C. Muller, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSArray+customSort.h"

@interface PBCModel : NSObject <NSTableViewDataSource>
{
	NSArray   *stations;
	NSInteger stationsCount;
	NSNumber  *stationPlaying;
}

- (void) loadStations:(NSString *)filterBy;
- (IBAction) tableViewSelected:(id)sender;

@property(nonatomic, retain) NSArray  *stations;
@property(nonatomic, retain) NSNumber *stationPlaying;

@end
