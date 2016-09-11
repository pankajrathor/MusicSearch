//
//  ViewController.m
//  MusicSearch
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Pankaj Rathor. All rights reserved.
//

#import "SearchMusicViewController.h"
#import "TrackCell.h"
#import "SongListActivity.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SearchMusicViewController () < UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SongListActivityDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *songSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *songsTableView;
@property (strong, nonatomic) NSArray *searchedTrackList;

@end

@implementation SearchMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// TODO: REMOVE HARDCODING
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // We just want to have 1 section for the table view
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = [self.searchedTrackList count];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackCell *trackCell = (TrackCell *)[tableView dequeueReusableCellWithIdentifier:@"TrackCellIdentifier"];

    [trackCell setupTrackCell:[self.searchedTrackList objectAtIndex:indexPath.row]];
    
    return trackCell;
}

#pragma mark Table View Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TrackCell *selectedTrackCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSURL *previewUrl = [selectedTrackCell previewLocalURL];
    
    if (previewUrl) {
        
        AVPlayer *player = [AVPlayer playerWithURL:previewUrl];
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:nil];
    }
}

#pragma Mark Search Bar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.songSearchBar resignFirstResponder];
    
    NSString *searchString = searchBar.text;
    [SongListActivity sharedInstance].delegate = self;
    [[SongListActivity sharedInstance] getSongListWithSearchText:searchString];
    
    [self.songSearchBar setShowsCancelButton:NO];
    [self.songSearchBar setText:@""];
    
    // Start the network activity indicator to visible on the status bar.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    // When the search bar editing starts, show the cancel button
    [self.songSearchBar setShowsCancelButton:YES];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // When the search bar cancel button is clicked, clear the search text and hide the keyboard.
    [self.songSearchBar setShowsCancelButton:NO];
    
    [self.songSearchBar setText:@""];
    [self.songSearchBar resignFirstResponder];
}

#pragma Mark SongListActivityDelegate 

- (void)didRecieveTracks:(NSArray *)tracks {
    
    // Dispatch the UI update event on the main thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Update the searchTrackList with the recieved tracks.
        self.searchedTrackList = tracks;
        
        // Reload the table with the latest track results.
        [self.songsTableView reloadData];
        
        // Stop the network activity indicator to visible on the status bar.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });
}

- (void)didRecieveError:(NSError *)error {
    NSLog(@"Error getting song list: %@", error.description);
    
    // TODO: Show alert
}

@end
