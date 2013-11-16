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
    __block NSArray *users = [NSArray new];
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            users = (NSArray *)jsonResponse;
        }
    };
    
    NSString *resourceURL = [NSString stringWithFormat:@"https://api.soundcloud.com/users.json?q=[%@]",city];
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:handler];
    
    NSMutableArray *scrubbedUsers = [NSMutableArray new];
    int foundUsers = [users count];
    
    // loop through all users found by the json query and filter them by users that are actually from
    // the given city that actually have tracks up
    for (int i = 0; i < foundUsers; ++i)
    {
        NSMutableDictionary *user = [users objectAtIndex:i];
        if ([[user objectForKey:@"city"] isEqualToString:city] &&
            !([user objectForKey:@"track_count"] == 0))
            [scrubbedUsers addObject:user];
    }
    
    int randSelector = arc4random() % [scrubbedUsers count];
    NSMutableDictionary *user = [scrubbedUsers objectAtIndex:randSelector];
    
    _track.artistInformation = user;
}

@end
