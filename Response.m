//
//  Response.m
//  Jayson
//
//  Created by Ben Yellin on 12/22/10.
//  Copyright 2010 Been Yelling. All rights reserved.
//

#import "Response.h"

@implementation Response
@synthesize source, responseType;

- (id)init {
	if (self = [super init]) {
		source = nil;
		responseType = DEFAULT_RESPONSE_TYPE;		
	}
	return self;
}

@end
