//
//  PianobarControlModel.m
//  PianobarControl
//
//  Created by Juan C. Müller on 3/7/11.
//

#import "PianobarControlModel.h"

@implementation PianobarControlModel

@synthesize stations;

#pragma mark Model methods
- (void) loadStations:(NSString*)filterBy {
	NSString* stationsFromFile = [NSString stringWithContentsOfFile:@"/tmp/pianobar_stations" encoding:NSUTF8StringEncoding error:nil];
	NSArray* stationsNotFiltered = [stationsFromFile componentsSeparatedByString:@"\n"];

	if ([filterBy isEqual:@""])
		[self setStations:stationsNotFiltered];
	else {
		NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", filterBy];
		[self setStations:[stationsNotFiltered filteredArrayUsingPredicate:regextest]];
	}

	stationsCount = [stations count];
}
#pragma mark -

#pragma mark NSTableViewDataSource protocol methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [stations count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	if (rowIndex > -1 && rowIndex < stationsCount)
		return [stations objectAtIndex:rowIndex];
	else 
		return nil;
}

- (IBAction) tableViewSelected:(id)sender {
}

#pragma mark -

@end
