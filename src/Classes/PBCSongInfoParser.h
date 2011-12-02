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

- (void) parse;
- (NSURL*) searchLyricsURL;

@property(nonatomic, readonly, retain) NSString* artist;
@property(nonatomic, readonly, retain) NSString* title;
@property(nonatomic, readonly, retain) NSString* album;
@property(nonatomic, readonly, retain) NSString* rating;
@property(nonatomic, readonly, retain) NSString* love;
@property(nonatomic, readonly, retain) NSString* currentSongString;

@end
