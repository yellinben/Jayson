//
//  NSString+Extras.h
//  Jayson
//
//  Created by The Yellin on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString (Extras)
- (NSString *)stringWithProperURLFormat;
- (BOOL)hasSupportedSchemePrefix;
@end
