//
//  ResponseDocument.h
//  Jayson
//
//  Created by Ben Yellin on 12/22/10.
//  Copyright 2010 Been Yelling. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "ResponseView.h"
#import "Response.h"
#import "ResponseLoader.h"

@interface ResponseDocument : NSDocument <NSToolbarDelegate, NSComboBoxDataSource, NSUserInterfaceValidations> {
	IBOutlet NSWindow *mainWindow;
	IBOutlet NSView *urlFieldView;
	IBOutlet NSComboBox *urlField;
	IBOutlet NSProgressIndicator *downloadSpinner;
	IBOutlet ResponseView *responseView;
	IBOutlet NSSegmentedControl *styledControl;
	
	NSURL *currentURL;
	Response *currentResponse;
	BOOL isDownloading; 

	NSMutableArray *history;
	NSInteger currentHistoryIndex;
	
	BOOL editingEnabled;
	BOOL showStyled;
}
@property (nonatomic, retain) NSURL *currentURL;
@property (nonatomic, retain) Response *currentResponse;

- (BOOL)isEmpty;

- (IBAction)openLocation:(id)sender;

- (IBAction)showStyled:(id)sender;
- (IBAction)showRaw:(id)sender;
- (IBAction)styledChange:(id)sender;
- (void)setShowStyled:(BOOL)flag;

- (IBAction)goToLocation:(id)sender;
- (void)loadURL:(NSURL *)aURL;
- (void)updateURL:(NSURL *)aURL;

- (void)setIsDownloading:(BOOL)flag;

- (IBAction)goBack:(id)sender;
- (BOOL)canGoBack;

- (IBAction)goForward:(id)sender;
- (BOOL)canGoForward;

- (IBAction)clearHistory:(id)sender;
- (BOOL)canClearHistory;

- (IBAction)reload:(id)sender;
- (BOOL)canReload;

- (IBAction)toggleEditingEnabled:(id)sender;
- (void)setEditingEnabled:(BOOL)flag;

- (IBAction)increaseTextSize:(id)sender;
- (IBAction)decreaseTextSize:(id)sender;
- (IBAction)actualTextSize:(id)sender;

@end
