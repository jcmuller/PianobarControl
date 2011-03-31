//
//  PianobarControlModel.m
//  PianobarControl
//
//  Created by Juan C. Müller on 3/7/11.
//

#import "NSString+Levenshtein.h"
//#import "NSString+DamerauLevenshtein.h"
#import "NSArray+customSort.h"
#import "PianobarControlModel.h"

@implementation PianobarControlModel

@synthesize stations;

#pragma mark Model methods
- (void) loadStations:(NSString*)filterBy {
	NSString* stationsFromFile = [NSString stringWithContentsOfFile:@"/tmp/pianobar_stations" encoding:NSUTF8StringEncoding error:nil];
	NSMutableArray* stationsNotFiltered = [NSMutableArray arrayWithArray:[stationsFromFile componentsSeparatedByString:@"\n"]];
	
	if ([filterBy isEqual:@""])
		[self setStations:stationsNotFiltered];
	else {
		// First, find any occurrences on filterBy in stationsNotFiltered. Then, sort by Levinshtein's distance
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", filterBy];
		NSMutableArray *stationsFromSearch = [NSMutableArray arrayWithArray:[stationsNotFiltered filteredArrayUsingPredicate:predicate]];
		
		NSEnumerator *enumerator = [stationsFromSearch objectEnumerator];
		NSString *station = NULL;
		while (station = [enumerator nextObject]) {
			[stationsNotFiltered removeObject:station];
		}
		[station release];
		
		NSMutableArray *stationsLike = [NSMutableArray array];
		float maxWeight = 0;
		
		enumerator = [stationsNotFiltered objectEnumerator];
		NSString *str = NULL;
		while (str = [enumerator nextObject]) {
			//NSNumber *weight = [NSNumber numberWithFloat:[filterBy distanceFromString:str options:JXLDCaseInsensitiveComparison]];
			NSNumber *weight = [NSNumber numberWithFloat:[filterBy compareWithString:str]];
			if ([weight floatValue] > maxWeight)
				maxWeight = [weight floatValue];
			[stationsLike addObject:[NSArray arrayWithObjects:weight, str, nil]];
		}
		[str release];
		
		[stationsLike sortUsingSelector:@selector(myCompare:)];
		
		NSArray *arr = NULL;
		enumerator = [stationsLike objectEnumerator];
		while (arr = [enumerator nextObject]) {
			NSNumber *weight = [arr objectAtIndex:0];
			if ([weight floatValue] <= maxWeight * 0.7)
				[stationsFromSearch addObject:[NSString stringWithFormat:@"%@ (%@)", [arr objectAtIndex:1], weight]];
		}
		[arr release];
		
		[self setStations:stationsFromSearch];
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
