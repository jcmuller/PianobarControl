//
//  JMSongInfoParser.m
//  PianobarControl
//
//  Created by Juan C. Müller on 9/4/11.
//  Copyright (c) 2011 Juan C. Muller, Inc. All rights reserved.
//

#import "PBCSongInfoParser.h"

@interface PBCSongInfoParser()

@property(nonatomic, readwrite, retain) NSString* artist;
@property(nonatomic, readwrite, retain) NSString* title;
@property(nonatomic, readwrite, retain) NSString* album;
@property(nonatomic, readwrite, retain) NSString* rating;
@property(nonatomic, readwrite, retain) NSString* love;
@property(nonatomic, readwrite, retain) NSString* currentSongString;

@end

@implementation PBCSongInfoParser

static NSString* fileName = @"/tmp/current_song_data";

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	if([key isEqualToString:@"current_song_string"])
	{
		[self setValue:value forKey:@"currentSongString"];
	}
	else if([key isEqualToString:@"station_name"])
	{
	}
	else
	{
		[super setValue:value forUndefinedKey:key];
	}
}

- (void) parse
{
	NSString *currentSongFileString = [NSString stringWithContentsOfFile:fileName
																encoding:NSUTF8StringEncoding
																   error:nil];
	NSDictionary *dic = [currentSongFileString JSONValue];
	for (NSString *key in [dic allKeys]) {
		NSString *thing = [dic valueForKey:key];
		[self setValue:thing forKey:key];
	}
}

- (NSURL*) searchLyricsURL
{
	[self parse];
	NSString *arguments = [NSString stringWithFormat:@"%@ %@ lyrics", [self artist], [self title]];
	NSString *enc = [(NSString*)CFURLCreateStringByAddingPercentEscapes(
																		NULL,
																		(CFStringRef)arguments,
																		NULL,
																		(CFStringRef)@";/?:@&=+$,",
																		kCFStringEncodingUTF8
																		) autorelease];
	NSURL *searchUrl = [NSURL URLWithString:
				 [NSString stringWithFormat:@"http://google.com/search?q=%@", enc]];
	return searchUrl;
}

@synthesize artist = _artist;
@synthesize title = _title;
@synthesize album = _album;
@synthesize rating = _rating;
@synthesize love = _love;
@synthesize currentSongString = _currentSongString;

- (void)dealloc {
    [_artist release];
	[_title release];
	[_album release];
	[_rating release];
	[_love release];
	[_currentSongString release];

    [super dealloc];
}

@end
