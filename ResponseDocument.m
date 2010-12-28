//
//  ResponseDocument.m
//  Jayson
//
//  Created by Ben Yellin on 12/22/10.
//  Copyright 2010 Been Yelling. All rights reserved.
//

#import "ResponseDocument.h"
#import "NSString+Extras.h"

static NSString *ToolbarItemURLFieldIdentifier = @"URL Field Toolbar Item";
static NSString *ToolbarItemReloadButtonIdentifier = @"Reload Button Toolbar Item";

@interface ResponseDocument (Private)
- (void)buildToolbar;
- (void)updateResponseView;
- (NSString *)titleForResponseType:(kResponseType)type;
- (kResponseType)responseTypeForTitle:(NSString *)title;
- (void)validateStyledControl;
- (void)loadHistoryItemAtIndex:(int)index;
@end

@implementation ResponseDocument
@synthesize currentURL, currentResponse;

- (id)init {
    self = [super init];
    if (self) {        
		[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
    return self;
}

- (void)dealloc {
	[history release];
	[super dealloc];
}

- (NSString *)windowNibName {
    return @"ResponseDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController {
    [super windowControllerDidLoadNib:aController];
	
	[self setIsDownloading:false];
	[self buildToolbar];
	
	currentResponse = [[Response alloc] init];
	
	[urlField setDataSource:self];
	history = [[NSMutableArray alloc] init];
	currentHistoryIndex = -1;
	
	[self setEditingEnabled:YES];
	showStyled = YES;
	
	[mainWindow makeFirstResponder:urlField];

	// If the current URL has already be set
	// (because of opening a local file)
	// the display that in the URL field
	if (currentURL != nil)
		[urlField setStringValue:[currentURL absoluteString]];
}

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {	
	NSLog(@"Type: %@", typeName);
	[self loadURL:absoluteURL];
	return YES;
}

- (BOOL)writeToURL:(NSURL *)absoluteURL 
			ofType:(NSString *)typeName 
			 error:(NSError **)outError {
	NSData *data = [currentResponse.source 
					dataUsingEncoding:NSUTF8StringEncoding];
	BOOL success = [data writeToURL:absoluteURL 
							options:NSAtomicWrite 
							  error:outError];
	return success;
}

// Overridden so that the document no longer reports unsaved 'changes'
- (void)updateChangeCount:(NSDocumentChangeType)changeType {}

#pragma mark Toolbar Stuuuuuff

- (void)buildToolbar {
	NSToolbar *toolbar = [[[NSToolbar alloc] initWithIdentifier:@"JaysonDocumentToolbar"] autorelease];
	
	[toolbar setAllowsUserCustomization:YES];
	[toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
	[toolbar setDelegate:self];

	[mainWindow setToolbar:toolbar];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
	return [NSArray arrayWithObjects:ToolbarItemURLFieldIdentifier,
			ToolbarItemReloadButtonIdentifier,
			NSToolbarFlexibleSpaceItemIdentifier, 
			NSToolbarSpaceItemIdentifier, 
			NSToolbarSeparatorItemIdentifier, nil];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
	return [NSArray arrayWithObject:ToolbarItemURLFieldIdentifier];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar 
	 itemForItemIdentifier:(NSString *)itemIdentifier 
 willBeInsertedIntoToolbar:(BOOL)flag {
	NSToolbarItem *item = nil;
	
	if ([itemIdentifier isEqualTo:ToolbarItemURLFieldIdentifier]) {
		item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
		[item setLabel:@"Location Field"];
		[item setPaletteLabel:@"Location Field"];
		[item setToolTip:@"Location Field"];
		[item setView:urlFieldView];
		[item setMinSize:NSMakeSize(50, 23)];
		[item setMaxSize:NSMakeSize(5000, 23)];
	} else if ([itemIdentifier isEqualTo:ToolbarItemReloadButtonIdentifier]) {		
		NSButton *reloadButton = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 28, 22)];
		[reloadButton setImage:[NSImage imageNamed:NSImageNameRefreshTemplate]];
		[reloadButton setBezelStyle:NSTexturedRoundedBezelStyle];
		[reloadButton setAction:@selector(reload:)];
		[reloadButton setTarget:self];
		[reloadButton setEnabled:[self canReload]];		
		
		item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
		[item setLabel:@"Reload"];
		[item setPaletteLabel:@"Reload"];
		[item setToolTip:@"Reload Document"];
		[item setView:reloadButton]; 
	}
	
	return [item autorelease];
}

#pragma mark URL Field Combo Box Data Source

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	return [history count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
	return [[history objectAtIndex:index] absoluteString];
}

- (BOOL)isEmpty {
	return (currentResponse == nil) && (currentURL == nil);
}

- (void)updateResponseView {
	[responseView displayResponseFormatted:currentResponse];	
}

- (void)validateStyledControl {
	[styledControl setEnabled:(![self isEmpty] && !isDownloading)];
}

- (IBAction)showStyled:(id)sender {
	[self setShowStyled:YES];
}

- (IBAction)showRaw:(id)sender {
	[self setShowStyled:NO];
}

- (IBAction)styledChange:(id)sender {
	BOOL flag = ([sender selectedSegment] == 0);
	[self setShowStyled:flag];
}

- (void)setShowStyled:(BOOL)flag {
	showStyled = flag;
	
	if (showStyled) {
		[responseView displayResponseFormatted:currentResponse];
	} else {
		[responseView displayResponseUnformatted:currentResponse];
	}
	
	[styledControl setSelectedSegment:(flag ? 0 : 1)];
}

- (IBAction)goToLocation:(id)sender {
	NSString *properURLString = [[urlField stringValue] stringWithProperURLFormat];
	[urlField setStringValue:properURLString];
	
	NSURL *newURL = [NSURL URLWithString:properURLString];
	[self loadURL:newURL];	
}

- (void)loadURL:(NSURL *)aURL {
	NSLog(@"loadURL: %@", aURL);
	
	self.currentURL = aURL;
	ResponseLoader *responseLoader = [[ResponseLoader alloc] initWithURL:currentURL];
	responseLoader.delegate = self;
	[responseLoader start];
	
	if (![history containsObject:currentURL]) {
		[history addObject:currentURL];
	}
	currentHistoryIndex = [history indexOfObject:currentURL];
	
	[mainWindow setTitle:[currentURL absoluteString]];
	[self validateStyledControl];
}

- (void)updateURL:(NSURL *)aURL {
	[urlField setStringValue:[aURL absoluteString]];
	[self loadURL:aURL];
}

- (void)setIsDownloading:(BOOL)flag {
	isDownloading = flag;		
	if (isDownloading) {
		[downloadSpinner startAnimation:nil];
		[responseView setAlphaValue:0.5];
	} else {
		[downloadSpinner stopAnimation:nil];
		[responseView setAlphaValue:1.0];
	}
}

#pragma mark ResponseLoaderDelegate

- (void)responseLoaderDidBegin:(ResponseLoader *)loader {
	[self setIsDownloading:YES];
}

- (void)responseLoader:(ResponseLoader *)loader didFinishWithResponse:(Response *)aResponse {
	self.currentResponse = aResponse;	
	[self setIsDownloading:NO];
	[self updateResponseView];
}

- (void)responseLoader:(ResponseLoader *)loader didFailWithError:(NSError *)error {
	NSLog(@"Did Fail: %@", [error description]);
	[self setIsDownloading:NO];
	[loader release];
	[responseView displayError:[error description]];
}

- (IBAction)openLocation:(id)sender {
	[mainWindow makeFirstResponder:urlField];
}

#pragma mark History

- (IBAction)goBack:(id)sender {
	if ([self canGoBack]) {
		[self loadHistoryItemAtIndex:
		 currentHistoryIndex-1];
	}
}

- (BOOL)canGoBack {
	return (currentHistoryIndex > 0);
}

- (IBAction)goForward:(id)sender {
	if ([self canGoForward]) {
		[self loadHistoryItemAtIndex:
		 currentHistoryIndex+1];
	}
}

- (BOOL)canGoForward {
	return (currentHistoryIndex < [history count]-1);
}

- (void)loadHistoryItemAtIndex:(int)index {
	if (index < [history count]) {
		currentHistoryIndex = index;
		NSURL *historyURL = [history objectAtIndex:index];
		[urlField setStringValue:[historyURL absoluteString]];
		[self goToLocation:nil];
	}
}

- (IBAction)clearHistory:(id)sender {
	if ([self canClearHistory]) {
		[history release];
		history = [[NSMutableArray alloc] init];
		currentHistoryIndex -1;
	}
}

- (BOOL)canClearHistory {
	return ([history count] > 0);
}

- (IBAction)reload:(id)sender {
	if ([self canReload]) {
		[urlField setStringValue:[currentURL absoluteString]];
		[self goToLocation:sender];
	}
}

- (BOOL)canReload {
	return (currentHistoryIndex > -1) && !isDownloading;
}

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem {
	SEL selector = [anItem action];
	
	if (selector == @selector(goBack:)) {
		return [self canGoBack];
	} else if (selector == @selector(goForward:)) {
		return [self canGoForward];
	} else if (selector == @selector(clearHistory:)) {
		return [self canClearHistory];
	} else if (selector == @selector(reload:)) {
		return [self canReload];
	} else if (selector == @selector(increaseTextSize:)) {
		return [responseView canMakeTextLarger];
	} else if (selector == @selector(decreaseTextSize:)) {
		return [responseView canMakeTextSmaller];
	} else if (selector == @selector(actualTextSize:)) {
		return [responseView canMakeTextStandardSize];
	}
	
	return [super validateUserInterfaceItem:anItem];
}

- (IBAction)toggleEditingEnabled:(id)sender {
	[self setEditingEnabled:!editingEnabled];
	
	if ([sender class] == [NSMenuItem class]) {
		NSString *titleEnd = (editingEnabled) ? @"Enabled" : @"Disabled";
		[sender setTitle:[@"Editing " stringByAppendingString:titleEnd]];		
		[sender setState:(NSInteger)editingEnabled];
	}
}

- (void)setEditingEnabled:(BOOL)flag {
	editingEnabled = flag;
	[responseView setEditable:editingEnabled];
}

- (IBAction)increaseTextSize:(id)sender {
	[responseView makeTextLarger:sender];
}

- (IBAction)decreaseTextSize:(id)sender {
	[responseView makeTextSmaller:sender];
}
- (IBAction)actualTextSize:(id)sender {
	[responseView makeTextStandardSize:sender];
}

@end
