//
//  Response.h
//  Jayson
//
//  Created by Ben Yellin on 12/22/10.
//  Copyright 2010 Been Yelling. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	kResponsePlain,
	kResponseXML,
	kResponseJSON
} kResponseType;

static kResponseType DEFAULT_RESPONSE_TYPE = kResponseJSON;

@interface Response : NSObject {
	NSString *source;
	kResponseType responseType;	
}

@property (nonatomic, retain) NSString *source;
@property (readwrite) kResponseType responseType;

@end
