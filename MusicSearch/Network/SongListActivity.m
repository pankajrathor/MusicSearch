//
//  SongListActivity.m
//  This class downloads the list of matching results from the iTunes store. Search URL is https://itunes.apple.com/search?media=music&entity=song&term= 
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Pankaj Rathor. All rights reserved.
//

#import "SongListActivity.h"
#import "Constants.h"
#import "Track.h"
#import "AppDelegate.h"

@interface SongListActivity ()

// Property to hold the NSURLSession object
@property (strong, nonatomic) NSURLSession *songListSession;

// Property to hold the NSURLSessionDataTask to fetch the search results
@property (strong, nonatomic) NSURLSessionDataTask *songListDataTask;

// Property to hold the list of songs.
@property (strong, nonatomic) NSMutableArray *songList;

@end

@implementation SongListActivity

+(instancetype) sharedInstance {
    // Create a static instance for this class
    static SongListActivity *sharedInstance = nil;
    
    // dispatch_once implmentation to ensure only one instance of this class is created.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        // setup the NSURLSession
        [sharedInstance initializeSession];
    });
    
    // return the static instance
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
        
        // URL Encoding will be required for the search term
        NSCharacterSet *expectedCharSet = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *querySearchParameter = [searchText stringByAddingPercentEncodingWithAllowedCharacters:expectedCharSet];
        
        // Create a mutable string from the base url
        NSMutableString *searchUrlString = [NSMutableString stringWithString:iTunesUrlString];
        // Append the search term to the base url
        [searchUrlString appendString:querySearchParameter];
        
        // Create an NSURL out of the search URL string
        NSURL *searchUrl = [NSURL URLWithString:searchUrlString];
        
        // Create a data task for intiating the request.
        self.songListDataTask = [self.songListSession dataTaskWithURL:searchUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            
            // Check if there is an error while getting the response.
            if (error == nil) {
                
                // Check for the status code if its 200 OK.
                if ([(NSHTTPURLResponse *)response statusCode] == 200) {
                    
                    // Parse the response data and save it in
                    [self createSongListFromData:data];
                    
                    // Check if the delegate object is valid.
                    if (self.delegate) {
                        if ([self.delegate respondsToSelector:@selector(didRecieveTracks:)])
                            [self.delegate didRecieveTracks:self.songList];
                    }
                }
                else {
                    // Status code is not correct and hence we cannot proceed further.
                    NSLog(@"HTTP Status code is not OK: %d", (int)[(NSHTTPURLResponse *)response statusCode]);
                    // TODO: Add Alert
                }
            }
            else {
                NSLog(@"Error retrieving song list: %@", error.localizedDescription);
                
                if (self.delegate) {
                    if ([self.delegate respondsToSelector:@selector(didRecieveError:)])
                        [self.delegate didRecieveError:error];
                }
            }
            
        }];
        
        [self.songListDataTask resume];
    }
    else {
        // No search string specified.
    }
}

// Method to parse the response NSData and store the Track object in an array.
- (void) createSongListFromData:(NSData *) data {
    
    // Empty the song list. We have got new song list.
    [self.songList removeAllObjects];
    
    // Error object for parsing JSON
    NSError *jsonParseError = nil;
    
    // Using NSJSONSerialization, convert the data to dictionary
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonParseError];
    
    // Check for any JSON parsing error.
    if (jsonParseError == nil) {
        
        // Get the array of searched songs
        NSArray *songArray = [responseDictionary objectForKey:@"results"];
        
        if (songArray != nil && songArray.count != 0) {
            
            // Iterate through the Array to get Song Details dictionary for each result.
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
}

@end
