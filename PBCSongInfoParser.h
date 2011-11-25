//
//  JMSongInfoParser.h
//  PianobarControl
//
//  Created by Juan C. Müller on 9/4/11.
//  Copyright (c) 2011 Juan C. Muller, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@interface PBCSongInfoParser : NSObject
{
	NSString *fileName;
@private
	NSDictionary *songDataDictionary;
}

- (void) parse;
- (NSURL*) searchLyricsURL;

- (NSString*) artist;
- (NSString*) title;
- (NSString*) album;
- (NSString*) rating;
- (NSString*) love;
- (NSString*) currentSongString;

@property(nonatomic, retain) NSString *fileName;
@property(nonatomic, retain) NSDictionary *songDataDictionary;

@end
