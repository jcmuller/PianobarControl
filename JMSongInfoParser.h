//
//  JMSongInfoParser.h
//  PianobarControl
//
//  Created by Juan C. Müller on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@interface JMSongInfoParser : NSObject {
    NSString* fileName;
@private
    NSDictionary* songDataDictionary;
}

- (void) parse;

- (NSString*) artist;
- (NSString*) title;
- (NSString*) album;
- (NSString*) rating;
- (NSString*) love;
- (NSString*) currentSongString;

@property(nonatomic, retain) NSString *fileName;
@property(nonatomic, retain) NSDictionary *songDataDictionary;


@end