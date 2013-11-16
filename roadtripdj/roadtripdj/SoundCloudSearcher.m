//
//  SoundCloudSearcher.m
//  roadtripdj
//
//  Created by Sasha Heinen on 11/15/13.
//  Copyright (c) 2013 Sasha Heinen. All rights reserved.
//

#import "SoundCloudSearcher.h"

@implementation SoundCloudSearcher

-(void)handleCity:(NSString *)city
{
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            NSArray *users = (NSArray *)jsonResponse;
            [self scrubUsers:users fromCity:city];
        }
    };
    
    NSString *encodedCity = [city stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *resourceURL = [NSString stringWithFormat:@"https://api.soundcloud.com/users.json?client_id=b27fd7cbc5bb8d6cb96603dfabe525ac&q=[%@]",encodedCity];
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:handler];
}

-(void)scrubUsers:(NSArray *)users fromCity:(NSString *)city
{
    NSMutableArray *scrubbedUsers = [NSMutableArray new];
    int foundUsers = [users count];
    
    // loop through all users found by the json query and filter them by users that are actually from
    // the given city that actually have tracks up
    for (int i = 0; i < foundUsers; ++i)
    {
        NSMutableDictionary *user = [users objectAtIndex:i];
        if (!((NSNull *) [user objectForKey:@"city"] == [NSNull null])) {
            if ([[user objectForKey:@"city"] isEqualToString:city] &&
                !([user objectForKey:@"track_count"] == 0))
                [scrubbedUsers addObject:user];
        }
    }
    
    
    NSMutableDictionary *user;
    int randSelector;
    
    // make sure there are users for the given city!
    if ([scrubbedUsers count] > 0) {
        randSelector = arc4random() % [scrubbedUsers count];
        user = [scrubbedUsers objectAtIndex:randSelector];
    } else {
        randSelector = arc4random() % [users count];
        user = [users objectAtIndex:randSelector];
    }
    
    _track.artistInformation = user;
    NSLog(@"Hi!");
    NSLog([user objectForKey:@"full_name"]);
    
    [self handleArtist:[user objectForKey:@"id"]];
}

-(void)handleArtist:(NSString *)user_id
{
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            NSArray *tracks = (NSArray *)jsonResponse;
            [self selectTrack:tracks];
        }
    };

    NSString *resourceURL = [NSString stringWithFormat:@"https://api.soundcloud.com/users/%@/tracks.json?client_id=b27fd7cbc5bb8d6cb96603dfabe525ac",user_id];
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:handler];
}

-(void)selectTrack:(NSArray *)tracks
{
    int randTrack = arc4random() % [tracks count];
    
    NSMutableDictionary *track = [tracks objectAtIndex:randTrack];
    _track.trackInformation = track;
    
    [SCRequest performMethod:SCRequestMethodGET
                onResource:[NSURL URLWithString:[track objectForKey:@"stream_url"]]
                usingParameters:nil
                withAccount:nil
                sendingProgressHandler:nil
                responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                 [self setTrackData:data];
             }];
    
    NSLog([NSString stringWithFormat:@"song is %@", [track objectForKey:@"title"]]);
    
}

-(void)setTrackData:(NSData *)data
{
    _track.data = data;
    [self doneSearching];
}

-(void)doneSearching
{
    [_target performSelector:_action withObject:_track];
}

@end
