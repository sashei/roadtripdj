//
//  INETData.m
//  roadtripdj
//
//  Created by Sasha Heinen on 11/17/13.
//  Copyright (c) 2013 Sasha Heinen. All rights reserved.
//

#import "INETData.h"

@implementation INETData

- (id)initWithURL:(NSURL *)url andTarget:(id)target andAction:(SEL)action
{
    self = [super init];
    if (self) {
        self.connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
        _target = target;
        _action = action;
    }
    return self;
}

- (void)requestDataWithURLFromString:(NSString *)url
{
    if (self.connection) {
        [self.connection cancel];
    }
    
    self.connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] delegate:self];
    
    if (self.connection) {
        [self.connection start];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [NSData new];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    _data = data;
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_target performSelector:_action withObject:_data];
}

@end
