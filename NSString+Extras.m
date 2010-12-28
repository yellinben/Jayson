//
//  NSString+Extras.m
//  Jayson
//
//  Created by The Yellin on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+Extras.h"

NSString *const kHTTPPrefix = @"http://"; 
NSString *const kHTTPSPrefix = @"https://";
NSString *const kFilePrefix = @"file://"; 

@implementation NSString (Extras)

// URL formatting based code from Fluidium
// https://github.com/itod/fluidium

- (NSString *)stringWithProperURLFormat {
	if (![self hasSupportedSchemePrefix]) {
		return [kHTTPPrefix stringByAppendingString:self];
	}
	return self;
}

- (BOOL)hasSupportedSchemePrefix {
	return [self hasPrefix:kHTTPPrefix]
		|| [self hasPrefix:kHTTPSPrefix]
		|| [self hasPrefix:kFilePrefix];
}

@end
