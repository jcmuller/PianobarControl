//
//  PianobarControlModel.m
//  PianobarControl
//
//  Created by Juan C. Müller on 3/7/11.
//  Copyright (c) 2011 Juan C. Muller, Inc. All rights reserved.
//

#import "NSString+Levenshtein.h"
#import "NSArray+customSort.h"
#import "PBCModel.h"

@implementation PBCModel

#pragma mark Model methods
- (void) loadStations:(NSString*)filterBy
{
	NSString* stationsFromFile = [NSString stringWithContentsOfFile:@"/tmp/pianobar_stations"
														   encoding:NSUTF8StringEncoding error:nil];
	NSMutableArray* stationsNotFiltered = [NSMutableArray arrayWithArray:[stationsFromFile componentsSeparatedByString:@"\n"]];

	if ([filterBy isEqual:@""])
		[self setStations:stationsNotFiltered];
	else
	{
		// First, find any occurrences on filterBy in stationsNotFiltered. Then, sort by Levenshtein's distance
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", filterBy];
		NSMutableArray *stationsFromSearch = [NSMutableArray arrayWithArray:[stationsNotFiltered filteredArrayUsingPredicate:predicate]];

		NSEnumerator *enumerator = [stationsFromSearch objectEnumerator];
		NSString *station = NULL;
		while (station = [enumerator nextObject])
			[stationsNotFiltered removeObject:station];

		[station release];

		NSMutableArray *stationsLike = [NSMutableArray array];
		float maxWeight = 0;

		enumerator = [stationsNotFiltered objectEnumerator];
		NSString *str = NULL;
		while (str = [enumerator nextObject])
		{
			NSNumber *weight = [NSNumber numberWithFloat:[filterBy compareWithString:str]];
			if ([weight floatValue] > maxWeight)
				maxWeight = [weight floatValue];
			[stationsLike addObject:[NSArray arrayWithObjects:weight, str, nil]];
		}
		[str release];

		[stationsLike sortUsingSelector:@selector(myCompare:)];

		NSArray *arr = NULL;
		enumerator = [stationsLike objectEnumerator];
		while (arr = [enumerator nextObject])
		{
			NSNumber *weight = [arr objectAtIndex:0];
			if ([weight floatValue] <= maxWeight * 0.7)
				[stationsFromSearch addObject:[NSString stringWithFormat:@"%@ (%@)", [arr objectAtIndex:1], weight]];
		}
		[arr release];

		[self setStations:stationsFromSearch];
	}

	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[playing\\]"
																		   options:0 error:nil];
	for (int i = 0; i < [[self stations] count]; i++)
	{
		NSString *station = (NSString*)[[self stations] objectAtIndex:i];

		if ([regex numberOfMatchesInString:station options:0 range:NSMakeRange(0, [station length])] == 1)
		{
			[self setStationPlaying:[NSNumber numberWithInt:i]];
			break;
		}
	}
}
#pragma mark -

#pragma mark NSTableViewDataSource protocol methods
- (NSInteger) numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [[self stations] count];
}

- (id) tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(NSInteger)rowIndex
{
	if (rowIndex > -1 && rowIndex < [[self stations] count])
		return [[self stations] objectAtIndex:rowIndex];
	else
		return nil;
}

- (IBAction) tableViewSelected:(id)sender
{
}

#pragma mark -

@synthesize stations = _stations;
@synthesize stationPlaying = _stationPlaying;

#pragma mark NSObject
- (void) dealloc
{
	[_stations release];
	[_stationPlaying release];
	[super dealloc];
}
#pragma mark -


@end
