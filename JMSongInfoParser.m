//
//  JMSongInfoParser.m
//  PianobarControl
//
//  Created by Juan C. Müller on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JMSongInfoParser.h"

@implementation JMSongInfoParser

@synthesize fileName;
@synthesize songDataDictionary;

- (id)init
{
    self = [super init];
    if (self)
    {
        fileName = @"/tmp/current_song_data";
    }
    
    return self;
}

- (void) parse
{
	NSString *currentSongFileString = [NSString stringWithContentsOfFile:fileName
                                                                encoding:NSUTF8StringEncoding
                                                                   error:nil];
    songDataDictionary = [currentSongFileString JSONValue];
}

- (NSString*) artist
{
    return [songDataDictionary objectForKey:@"artist"];
}

- (NSString*) title
{
    return [songDataDictionary objectForKey:@"title"];    
}

- (NSString*) album
{
    return [songDataDictionary objectForKey:@"album"];
}

- (NSString*) rating
{
    return [songDataDictionary objectForKey:@"rating"];
}

- (NSString*) love
{
    return [songDataDictionary objectForKey:@"love"];
}

- (NSString*) currentSongString
{
    return [songDataDictionary objectForKey:@"current_song_string"];
}

- (NSURL*) searchLyricsURL
{
    [self parse];
    NSString *arguments = [NSString stringWithFormat:@"%@ %@ lyrics", [self artist], [self title]];
    NSString *enc       = [arguments stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL    *searchUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://google.com/search?q=%@", enc]];
    return searchUrl;
}

- (void) dealloc
{
    [fileName release];
    [songDataDictionary release];
    [super dealloc];
}

@end
