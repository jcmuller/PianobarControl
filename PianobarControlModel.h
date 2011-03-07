//
//  PianobarControlModel.h
//  PianobarControl
//
//  Created by Juan C. Müller on 3/7/11.
//  Copyright 2011 Challenge Post. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PianobarControlModel : NSObject <NSTableViewDataSource> {	
	NSArray *stations;
	NSInteger stationsCount;
}

- (void) loadStations:(NSString *)filterBy;

// for some reason, we have to mark 'em actions...
- (IBAction) tableViewSelected:(id)sender;

@property(nonatomic, retain) NSArray *stations;

@end
