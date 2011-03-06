//
//  NSAttributedString+Hyperlink.h
//  PianobarControl
//
//  Created by Juan C. Müller on 3/6/11.
//
// From:
// http://developer.apple.com/library/mac/#qa/qa2006/qa1487.html

#import <Cocoa/Cocoa.h>


@interface NSAttributedString (Hyperlink)

+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;

@end
