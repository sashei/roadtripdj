//
//  Track.m
//  roadtripdj
//
//  Created by Sasha Heinen and Rupert Deese on 11/15/13.
//  Copyright (c) 2013 Sasha Heinen and Rupert Deese. All rights reserved.
//

#import "Track.h"

@implementation Track

-(id)initWithTrack:(NSMutableDictionary *)track andArtist:(NSMutableDictionary *)artist andData:(NSData *)data
{
    self = [super init];
    if (self) {
        _trackInformation = track;
        _artistInformation = artist;
        _data = data;
    }
    
    return self;
}

@end
