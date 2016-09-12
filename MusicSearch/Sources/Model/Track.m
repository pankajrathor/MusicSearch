//
//  Track.m
//  MusicSearch
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "Track.h"
#import "FileHelper.h"
#import "Constants.h"

@implementation Track

- (instancetype) initWithDictionary:(NSDictionary *) dictionary {
    
    self = [super init];
    if (self) {
        self.name = dictionary[kTrackName];
        self.artist = dictionary[kArtist];
        self.previewURL = dictionary[kPreviewUrl];
        self.artworkURL = dictionary[kArtworkUrl];
    }
    
    return self;
}

- (BOOL) shouldDownloadFile {
    return [[FileHelper sharedHelper] shouldDownloadFileForURL:self.previewURL];
}

- (NSURL *) previewLocalURL {
    NSString *previewFileLocalPath = [[FileHelper sharedHelper] localPathForURL:self.previewURL];
    if ([[NSFileManager defaultManager] fileExistsAtPath:previewFileLocalPath]) {
        return [[NSURL alloc]initFileURLWithPath:previewFileLocalPath];
    }

    return nil;
}

- (BOOL) deletePreviewFile {
    if(!self.previewLocalURL) {//There is no need to delete the file. As the file does not exists.
        return YES;
    }
    return [[FileHelper sharedHelper] removeItemAtPath:[[FileHelper sharedHelper] localPathForURL:self.previewURL]];
}

@end
