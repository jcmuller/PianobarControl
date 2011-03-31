//
//  NSArray+customSort.m
//  PianobarControl
//
//  Created by Juan C. Müller on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSArray+customSort.h"


@implementation NSArray (customSort)

- (NSComparisonResult) myCompare:(NSArray *)obj {
	NSNumber *my_idx  = [self objectAtIndex:0];
	NSNumber *obj_idx = [obj objectAtIndex:0];
	NSComparisonResult retVal = NSOrderedSame;
	
	if ([my_idx floatValue] < [obj_idx floatValue])
		retVal = NSOrderedAscending;
	else if ([my_idx floatValue] > [obj_idx floatValue])
		retVal = NSOrderedDescending;
	
	return retVal;
}

@end
