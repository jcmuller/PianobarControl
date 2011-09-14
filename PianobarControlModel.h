//
//  PianobarControlModel.h
//  PianobarControl
//
//  Created by Juan C. Müller on 3/7/11.
//

#import <Cocoa/Cocoa.h>
#import "NSArray+customSort.h"


@interface PianobarControlModel : NSObject <NSTableViewDataSource> {
	NSArray *stations;
	NSInteger stationsCount;
	NSNumber *stationPlaying;
}

- (void) loadStations:(NSString *)filterBy;

// for some reason, we have to mark 'em actions...
- (IBAction) tableViewSelected:(id)sender;

@property(nonatomic, retain) NSArray *stations;
@property(nonatomic, retain) NSNumber *stationPlaying;

@end
