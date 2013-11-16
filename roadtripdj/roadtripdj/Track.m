//
//  Track.m
//  roadtripdj
//
//  Created by Sasha Heinen on 11/15/13.
//  Copyright (c) 2013 Sasha Heinen. All rights reserved.
//

#import "Track.h"

@implementation Track

-(id)initWithTrack:(NSMutableDictionary *)track andArtist:(NSMutableDictionary *)artist
{
    self = [super init];
    if (self) {
        _trackInformation = track;
        _artistInformation = artist;
    }
    
    return self;
}

@end
