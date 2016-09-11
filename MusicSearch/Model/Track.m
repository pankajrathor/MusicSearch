//
//  Track.m
//  MusicSearch
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Pankaj Rathor. All rights reserved.
//

#import "Track.h"

@implementation Track

- (instancetype)initWithName:(NSString *)name artist:(NSString *)artist previewUrl:(NSString *)previewUrl artworkUrl:(NSString *)artworkURL {
    
    self = [super init];
    if (self) {
        self.name = name;
        self.artist = artist;
        self.previewURL = previewUrl;
        self.artworkURL = artworkURL;
    }
    
    return self;
}

@end
