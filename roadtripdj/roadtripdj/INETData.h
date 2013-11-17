//
//  INETData.h
//  roadtripdj
//
//  Created by Sasha Heinen on 11/17/13.
//  Copyright (c) 2013 Sasha Heinen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INETData : NSObject <NSURLConnectionDelegate>

@property NSURLConnection *connection;
@property NSData *data;

@property id target;
@property SEL action;

- (id)initWithURL:(NSURL *)url andTarget:(id)target andAction:(SEL)action;

- (void)requestDataWithURLFromString:(NSString *)url;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
