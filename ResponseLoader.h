//
//  ResponseLoader.h
//  Jayson
//
//  Created by Ben Yellin on 12/22/10.
//  Copyright 2010 Been Yelling. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Response.h"

/*@protocol ResponseLoaderDelegate <NSObject>;
- (void)responseLoaderDidBegin:(ResponseLoader *)loader;
- (void)responseLoader:(ResponseLoader *)loader didFinishWithResponse:(Response *)aResponse;
- (void)responseLoader:(ResponseLoader *)loader didFailWithError:(NSError *)error;
@end*/

@interface ResponseLoader : NSObject {
	NSURL *url;
	NSMutableData *responseData;
	NSString *mimeType;
	id delegate;
}
@property (nonatomic, assign) id delegate;
- (id)initWithURL:(NSURL *)aURL;
- (void)start;
@end

@interface NSObject (ResponseLoaderDelegate)
- (void)responseLoaderDidBegin:(ResponseLoader *)loader;
- (void)responseLoader:(ResponseLoader *)loader didFinishWithResponse:(Response *)aResponse;
- (void)responseLoader:(ResponseLoader *)loader didFailWithError:(NSError *)error;
@end


