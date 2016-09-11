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
#import "FileDownloader.h"

@interface SearchMusicViewController () < UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SongListActivityDelegate,FileDownloaderDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *songSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *songsTableView;
@property (strong, nonatomic) NSArray *searchedTrackList;
@property (nonatomic,strong) NSTimer* timer;
@property (nonatomic) BOOL searchButtonTapped;

@end

@implementation SearchMusicViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [SongListActivity sharedInstance].delegate = self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    // We just want to have 1 section for the table view
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = [self.searchedTrackList count];
    return rows;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackCell *trackCell = (TrackCell *)[tableView dequeueReusableCellWithIdentifier:@"TrackCellIdentifier"];
    [trackCell setupTrackCell:self.searchedTrackList[indexPath.row]];
    trackCell.downloadButtonTappedBlock = self.trackCellDownloadButtonTappedBlock;
    
    return trackCell;
}

#pragma mark - Table View Delegate methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Track *track = self.searchedTrackList[indexPath.row];
    NSURL *previewUrl = track.previewLocalURL;
    
    if (previewUrl) {
        AVPlayer *player = [AVPlayer playerWithURL:previewUrl];
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:nil];
    }
}

#pragma mark - Search Bar Delegate Methods

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.songSearchBar resignFirstResponder];
    
    [self.songSearchBar setShowsCancelButton:NO];
   // [self.songSearchBar setText:@""];
    self.searchButtonTapped = YES;
    [self callSearchWebserivce];
}


- (TrackCellDownloadButtonTappedBlock)trackCellDownloadButtonTappedBlock {
    __weak typeof(self) weakSelf = self;
    TrackCellDownloadButtonTappedBlock block = ^(TrackCell *cell) {
        // When the download button is clicked, hide the Download button and show pause button, cancel button and download progress view.
        [cell hideOrShowDownloadButton:YES];
        [cell hideOrShowProgressView:NO];
        [cell setProgressValue:0.0];
        
        FileDownloader *previewDownloader = [[FileDownloader alloc] init];
        previewDownloader.delegate = weakSelf;
        
        [previewDownloader downloadFileWithURL:[NSURL URLWithString: cell.previewURL]];
        NSLog(@"URL %@",[NSURL URLWithString: cell.previewURL]);
        NSLog(@"fileURL %@",previewDownloader.fileURLString);
    };
    
    return block;
}

#pragma mark - FileDownloaderDelegate

- (void)fileDownloader:(FileDownloader *)downloader didFinishDownloadingToURL:(NSURL *)location {
    TrackCell *trackCell = [self cellForPreViewURL:downloader.fileURLString];
    [trackCell hideOrShowProgressView:YES];
}

- (void)fileDownloader:(FileDownloader *)downloader totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    TrackCell *trackCell = [self cellForPreViewURL:downloader.fileURLString];
    [trackCell setProgressValue:totalBytesWritten/totalBytesExpectedToWrite];
}

- (void)fileDownloader:(FileDownloader *)downloader didCompleteWithError:(NSError *)error {
    // TODO: handle download error
}


#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    // When the search bar editing starts, show the cancel button
    [self.songSearchBar setShowsCancelButton:YES];
    
    return YES;
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self performSearch];
    if(searchText.length == 0) {
        self.searchedTrackList = nil;
        [self.songsTableView reloadData];
    }
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // When the search bar cancel button is clicked, clear the search text and hide the keyboard.
    [self.songSearchBar setShowsCancelButton:NO];
    
    //[self.songSearchBar setText:@""];
    [self.songSearchBar resignFirstResponder];
    [[SongListActivity sharedInstance] cancelSearchOperations];
    
}

#pragma mark - Custom Methods.

- (void) performSearch {
    
    if(self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(callSearchWebserivce) userInfo:nil repeats:NO];
    
}

- (void) callSearchWebserivce {
    NSLog(@"Inside %s text = %@",__func__,self.songSearchBar.text);
    
    //If we are searching as user is typing then we will proceed only if user has entered at least 2 characters.
    //If user has clicked on seach button then we will not check the length of the search string.
    if(self.songSearchBar.text.length < 2 && !self.searchButtonTapped) {
        return;
    }
    
    NSString *searchString = self.songSearchBar.text;
    [[SongListActivity sharedInstance] getSongListWithSearchText:searchString];
    
    // Start the network activity indicator to visible on the status bar.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

- (TrackCell*)cellForPreViewURL:(NSString *)urlString {
    Track *track = (Track *)[self.searchedTrackList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%@ == previewURL",urlString]].firstObject;
    NSInteger index = [self.searchedTrackList indexOfObject:track];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    TrackCell* cell = [self.songsTableView cellForRowAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark - SongListActivityDelegate

- (void) didRecieveTracks:(NSArray *)tracks {
    // Update the searchTrackList with the recieved tracks.
    self.searchedTrackList = tracks;
    
    // Reload the table with the latest track results.
    [self.songsTableView reloadData];
    
    // Stop the network activity indicator to visible on the status bar.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //Reset the state of this variable
    self.searchButtonTapped = NO;
}

- (void) didRecieveError:(NSError *)error {
    NSLog(@"Error getting song list: %@", error.description);
    
    [self.songsTableView reloadData];
    
    // Stop the network activity indicator to visible on the status bar.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //Reset the state of this variable
    self.searchButtonTapped = NO;

}

@end
