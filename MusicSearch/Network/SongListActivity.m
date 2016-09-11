//
//  SongListActivity.m
//  MusicSearch
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Pankaj Rathor. All rights reserved.
//

#import "SongListActivity.h"
#import "Constants.h"
#import "Track.h"
#import "AppDelegate.h"

@interface SongListActivity ()

@property (strong, nonatomic) NSURLSession *songListSession;
@property (strong, nonatomic) NSURLSessionDataTask *songListDataTask;
@property (strong, nonatomic) NSMutableArray *songList;

@end

@implementation SongListActivity

+(instancetype) sharedInstance {
    
    static SongListActivity *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance initializeSession];
    });
    
    return sharedInstance;
}

- (void) initializeSession {
    // Create NSURLSession with default Session configuration.
    self.songListSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    // Initialize the songList
    self.songList = [[NSMutableArray alloc] init];
}

- (void) getSongListWithSearchText:(NSString *) searchText {
    
    // Check if the search string is nil or empty
    if ((searchText != nil) && (searchText.length > 0)) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSCharacterSet *expectedCharSet = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *querySearchParameter = [searchText stringByAddingPercentEncodingWithAllowedCharacters:expectedCharSet];
        NSMutableString *baseSearchUrl = [NSMutableString stringWithString:iTunesUrlString];
        [baseSearchUrl appendString:querySearchParameter];
        
        NSURL *searchUrl = [NSURL URLWithString:baseSearchUrl];
        
        self.songListDataTask = [self.songListSession dataTaskWithURL:searchUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            
            if (error == nil) {
                if ([(NSHTTPURLResponse *)response statusCode] == 200) {
                    [self createSongListFromData:data];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.delegate) {
                            if ([self.delegate respondsToSelector:@selector(didRecieveTracks:)])
                                [self.delegate didRecieveTracks:self.songList];
                            
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        }
                    });
                }
                else {
                    NSLog(@"HTTP Status code is not OK: %d", (int)[(NSHTTPURLResponse *)response statusCode]);
                    // TODO: Add Alert
                }
            }
            else {
                NSLog(@"Error retrieving song list: %@", error.localizedDescription);
                // TODO: Add Alert
            }
            
        }];
        
        [self.songListDataTask resume];
    }
    else {
        // No search string specified.
    }
}

- (NSArray *) createSongListFromData:(NSData *) data {
    
    // Empty the song list. We have got new song list.
    [self.songList removeAllObjects];
    
    // Error object for parsing JSON
    NSError *jsonParseError = nil;
    
    // Using NSJSONSerialization, convert the data to dictionary
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonParseError];
    
    if (jsonParseError == nil) {
        
        // Get the array of searched songs
        NSArray *songArray = [responseDictionary objectForKey:@"results"];
        
        if (songArray != nil && songArray.count != 0) {
            
            for (NSDictionary *songDetailsDictionary in songArray) {
                
                // Extract the name, artist, previewUrl & artworkUrl from the song details dictionary
                NSString *name = [songDetailsDictionary valueForKey:kTrackName];
                NSString *artist = [songDetailsDictionary valueForKey:kArtist];
                NSString *previewUrl = [songDetailsDictionary valueForKey:kPreviewUrl];
                NSString *artworkUrl = [songDetailsDictionary valueForKey:kArtworkUrl];
                
                // Initialize the Track object with the details
                Track *track = [[Track alloc] initWithName:name artist:artist previewUrl:previewUrl artworkUrl:artworkUrl];
                
                // Add the track object to the song list.
                [self.songList addObject:track];
            }
        }
        else {
            NSLog(@"No matching songs found for the search.");
            // TODO: Add alert
        }
            
    }
    else {
        NSLog(@"There was error parsing response: %@", jsonParseError.localizedDescription);
        //TODO: Add alert
    }

    return self.songList;
}

@end
