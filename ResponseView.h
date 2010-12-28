//
//  ResponseView.h
//  Jayson
//
//  Created by Ben Yellin on 12/22/10.
//  Copyright 2010 Been Yelling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebView.h>

@class Response;

@interface ResponseView : WebView {
	
}
- (void)displayResponseUnformatted:(Response *)resp;
- (void)displayResponseFormatted:(Response *)resp;
- (void)displayError:(NSString *)errorText;
@end
