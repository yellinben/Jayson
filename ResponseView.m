//
//  ResponseView.m
//  Jayson
//
//  Created by Ben Yellin on 12/22/10.
//  Copyright 2010 Been Yelling. All rights reserved.
//

#import "ResponseView.h"
#import "Response.h"

NSString *const JAYResponseViewJSON = @"json";
NSString *const JAYResponseViewRaw = @"raw";
NSString *const JAYResponseViewError = @"error";

@interface ResponseView (Private)
- (NSString *)generateUnformattedHTMLForResponse:(Response *)resp;
- (NSString *)generateFormattedHTMLForResponse:(Response *)resp;
- (NSString *)generateErrorHTMLForString:(NSString *)errorText;
- (NSString *)generateHTMLForString:(NSString *)source withType:(NSString *)responseViewType;
@end


@implementation ResponseView

- (id)initWithFrame:(NSRect)frameRect frameName:(NSString *)frameName groupName:(NSString *)groupName {
	if (self = [super initWithFrame:frameRect frameName:frameName groupName:groupName]) {
		
	}
	return self;
}

- (void)displayResponseUnformatted:(Response *)resp {	
	NSURL *resourceURL = [[NSBundle mainBundle] resourceURL];
	[[self mainFrame] loadHTMLString:[self generateUnformattedHTMLForResponse:resp]
							 baseURL:resourceURL];
}

- (void)displayResponseFormatted:(Response *)resp {
	NSURL *resourceURL = [[NSBundle mainBundle] resourceURL];
	[[self mainFrame] loadHTMLString:[self generateFormattedHTMLForResponse:resp] 
							 baseURL:resourceURL];
}

- (void)displayError:(NSString *)errorText {
	NSURL *resourceURL = [[NSBundle mainBundle] resourceURL];
	[[self mainFrame] loadHTMLString:[self generateErrorHTMLForString:errorText] 
							 baseURL:resourceURL];
}

- (NSString *)generateFormattedHTMLForResponse:(Response *)resp {
	return [self generateHTMLForString:resp.source withType:JAYResponseViewJSON];
}

- (NSString *)generateUnformattedHTMLForResponse:(Response *)resp {
	return [self generateHTMLForString:resp.source withType:JAYResponseViewRaw];
}

- (NSString *)generateErrorHTMLForString:(NSString *)errorText {
	NSString *headerErrorText = [NSString stringWithFormat:@"<h2>%@</h2>", errorText];
	return [self generateHTMLForString:headerErrorText withType:JAYResponseViewError];
}

- (NSString *)generateHTMLForString:(NSString *)source withType:(NSString *)responseViewType {
	NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"];
	NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:templatePath];

	[html replaceOccurrencesOfString:@"%%RESP%%" 
						  withString:source
							 options:NSLiteralSearch 
							   range:NSMakeRange(0, [html length])];
	[html replaceOccurrencesOfString:@"%%TYPE%%" 
						  withString:responseViewType
							 options:NSLiteralSearch 
							   range:NSMakeRange(0, [html length])];
	return [html autorelease];
}

@end
