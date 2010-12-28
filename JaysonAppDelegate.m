//
//  JaysonAppDelegate.m
//  Jayson
//
//  Created by Ben Yellin on 12/22/10.
//  Copyright 2010 Been Yelling. All rights reserved.
//

#import "JaysonAppDelegate.h"
#import "ResponseDocument.h"

@interface JaysonAppDelegate (Private)
- (void)getURL:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent;
@end


@implementation JaysonAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[[NSAppleEventManager sharedAppleEventManager] 
	 setEventHandler:self 
	 andSelector:@selector(getURL:withReplyEvent:) 
	 forEventClass:kInternetEventClass 
	 andEventID:kAEGetURL];

	[[NSDocumentController sharedDocumentController] makeUntitledDocumentOfType:@"public.data"];
}

- (void)getURL:(NSAppleEventDescriptor *)event 
		withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
	NSString *slurURLString = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
	NSLog(@"URL: %@", slurURLString);
	NSString *httpURLString = [slurURLString substringFromIndex:7];
	
	[self openNewDocumentAtURL:[NSURL URLWithString:httpURLString]];
}

- (void)openNewDocumentAtURL:(NSURL *)absoluteURL {
	NSDocumentController *docController = [NSDocumentController sharedDocumentController];
	[docController newDocument:nil];
	[(ResponseDocument *)[docController currentDocument] updateURL:absoluteURL];
}

@end
