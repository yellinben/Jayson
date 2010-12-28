//
//  ResponseLoader.m
//  Jayson
//
//  Created by Ben Yellin on 12/22/10.
//  Copyright 2010 Been Yelling. All rights reserved.
//

#import "ResponseLoader.h"

@interface ResponseLoader (Private)
- (void)beginDownload;
- (Response *)responseFromData:(NSData *)data;
@end


@implementation ResponseLoader
@synthesize delegate;

- (id)initWithURL:(NSURL *)aURL {
	if (self = [super init]) {
		url = [aURL copy];
		responseData = nil;
	}
	return self;
}

- (void)dealloc {
	[url release];
	[responseData release];
	[super dealloc];
}

- (void)start {
	[self beginDownload];
}

- (void)beginDownload {
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
	responseData = [[NSMutableData alloc] init];
	
	[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}

- (Response *)responseFromData:(NSData *)data {
	NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];	
	Response *resp = [[Response alloc] init];
	resp.source = [dataStr copy];
	
	kResponseType predictedType = DEFAULT_RESPONSE_TYPE;
	
	NSRange jsonRange = [[mimeType lowercaseString] rangeOfString:@"json"];
	if (jsonRange.location != NSNotFound)
		predictedType = kResponseJSON;
	
	NSRange xmlRange = [[mimeType lowercaseString] rangeOfString:@"xml"];	
	if (xmlRange.location != NSNotFound)
		predictedType = kResponseXML;
	
	resp.responseType = predictedType;
	
	[dataStr release];
	return resp;
}

#pragma mark NSURLConnection Stuuuuff

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
	if ([delegate respondsToSelector:@selector(responseLoaderDidBegin:)]) {
		[delegate responseLoaderDidBegin:self];
	}
	
	mimeType = [response MIMEType];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if ([delegate respondsToSelector:@selector(responseLoader:didFailWithError:)]) {
		[delegate responseLoader:self didFailWithError:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	if ([delegate respondsToSelector:@selector(responseLoader:didFinishWithResponse:)]) {
		[delegate responseLoader:self didFinishWithResponse:[self responseFromData:responseData]];
	}
	[responseData release];
}	

@end
