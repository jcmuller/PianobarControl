//
//  NSAttributedString+Hyperlink.h
//  PianobarControl
//
//  Created by Juan C. Müller on 3/6/11.
//

#import <Cocoa/Cocoa.h>


@interface NSAttributedString (Hyperlink)

+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;

@end
