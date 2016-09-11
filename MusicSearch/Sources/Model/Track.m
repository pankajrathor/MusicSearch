//
//  Track.m
//  MusicSearch
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Pankaj Rathor. All rights reserved.
//

#import "Track.h"
#import "FileHelper.h"
#import "Constants.h"

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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        self.name = [dictionary valueForKey:kTrackName];
        self.artist = [dictionary valueForKey:kArtist];
        self.previewURL = [dictionary valueForKey:kPreviewUrl];
        self.artworkURL = [dictionary valueForKey:kArtworkUrl];
    }
    
    return self;
}

- (BOOL)shouldDownloadFile {
    return [[FileHelper sharedHelper] shouldDownloadFileForURL:self.previewURL];
}

- (NSURL *)previewLocalURL {
    
    NSString *previewFileLocalPath = [[FileHelper sharedHelper] localPathForURL:self.previewURL];
    NSLog(@"Preview File at: %@", previewFileLocalPath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:previewFileLocalPath]) {
        return [NSURL URLWithString:previewFileLocalPath];
    }

    return nil;
}

@end
