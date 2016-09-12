//
//  SearchMusicViewController.m
//  SearchMusicViewController is the inititial view controller of the application. It provides a search bar
//  and then lists results matching the search in the table view below the search bar.
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SearchMusicViewController.h"
#import "TrackCell.h"
#import "TrackListActivity.h"
#import "FileDownloader.h"
#import "TrackManager.h"

@interface SearchMusicViewController () < UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, TrackListActivityDelegate,FileDownloaderDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *trackSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tracksTableView;

// Track Manager instance to manage the tracks
@property (strong, nonatomic) TrackManager *trackManager;

// Timer for tracking the typing speed.
@property (nonatomic,strong) NSTimer* typeTime;

@property (nonatomic) BOOL searchButtonTapped;

@end

@implementation SearchMusicViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [TrackListActivity sharedInstance].delegate = self;
    self.trackManager = [TrackManager sharedInstance];
}

#pragma mark - Table View Data source methods
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    // We just want to have 1 section for the table view
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = [[TrackManager sharedInstance] trackCount];
    return rows;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackCell *trackCell = (TrackCell *)[tableView dequeueReusableCellWithIdentifier:@"TrackCellIdentifier"];
    [trackCell setupTrackCell:[self.trackManager trackAtIndex:indexPath.row]];
    trackCell.downloadButtonTappedBlock = self.trackCellDownloadButtonTappedBlock;
    
    return trackCell;
}

#pragma mark - Table View Delegate methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Track *track =  [self.trackManager trackAtIndex:indexPath.row];
    NSURL *previewUrl = track.previewLocalURL;
    
    // Play the preview file using the AVPlayer
    if (previewUrl) {
        AVPlayer *player = [AVPlayer playerWithURL:previewUrl];
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:nil];
    }
}

#pragma mark - Search Bar Delegate Methods

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.trackSearchBar resignFirstResponder];
    
    [self.trackSearchBar setShowsCancelButton:NO];
    self.searchButtonTapped = YES;
    [self callSearchWebserivce];
}


- (TrackCellDownloadButtonTappedBlock) trackCellDownloadButtonTappedBlock {
    __weak typeof(self) weakSelf = self;
    TrackCellDownloadButtonTappedBlock block = ^(TrackCell *cell) {
        // When the download button is clicked, hide the Download button and show pause button, cancel button and download progress view.
        [cell hideDownloadButton:YES];
        [cell hideProgressView:NO];
        [cell setProgressValue:0.0];
        
        FileDownloader *previewDownloader = [[FileDownloader alloc] init];
        previewDownloader.delegate = weakSelf;
        
        [previewDownloader downloadFileWithURL:[NSURL URLWithString: cell.previewURL]];
    };
    
    return block;
}

#pragma mark - FileDownloaderDelegate

- (void) fileDownloader:(FileDownloader *)downloader didFinishDownloadingToURL:(NSURL *)location {
    TrackCell *trackCell = [self cellForPreViewURL:downloader.fileURLString];
    [trackCell hideProgressView:YES];
}

- (void) fileDownloader:(FileDownloader *)downloader totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    TrackCell *trackCell = [self cellForPreViewURL:downloader.fileURLString];
    [trackCell setProgressValue:((CGFloat)totalBytesWritten/(CGFloat)totalBytesExpectedToWrite)];
    
}

- (void) fileDownloader:(FileDownloader *)downloader didCompleteWithError:(NSError *)error {
    
    NSLog(@"File Download error: %@", error.localizedDescription);
    [self presentOkAlertWithTitle:@"Download Error" message:error.localizedDescription];
    
    TrackCell *trackCell = [self cellForPreViewURL:downloader.fileURLString];
    [trackCell hideDownloadButton:NO];
    [trackCell hideProgressView:YES];
}


#pragma mark - UISearchBarDelegate
- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    // When the search bar editing starts, show the cancel button
    [self.trackSearchBar setShowsCancelButton:YES];
    
    return YES;
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self performSearch];
    if (searchText.length == 0) {
        // Clear the track list
        [self.trackManager clearTrackList];
        
        // reload the table
        [self.tracksTableView reloadData];
    }
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // When the search bar cancel button is clicked, clear the search text and hide the keyboard.
    [self.trackSearchBar setShowsCancelButton:NO];
    [self.trackSearchBar resignFirstResponder];
    [[TrackListActivity sharedInstance] cancelSearchOperations];
    
}

#pragma mark - Custom Methods.

- (void) performSearch {
    
    if (self.typeTime.isValid) {
        [self.typeTime invalidate];
    }
    
    // setup a timer for initiating a search after 0.8 secs from typing end event
    self.typeTime = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(callSearchWebserivce) userInfo:nil repeats:NO];
    
}

// Invoke web service call to get the track list
- (void) callSearchWebserivce {
    //If we are searching as user is typing then we will proceed only if user has entered at least 2 characters.
    //If user has clicked on seach button then we will not check the length of the search string.
    if (self.trackSearchBar.text.length < 2 && !self.searchButtonTapped) {
        return;
    }
    
    NSString *searchString = self.trackSearchBar.text;
    [[TrackListActivity sharedInstance] getSongListWithSearchText:searchString];
    
    // Start the network activity indicator to visible on the status bar.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

// Get cell from the preview URL.
- (TrackCell*) cellForPreViewURL:(NSString *)urlString {
    
    Track *track = [self.trackManager trackFromPreviewUrl:urlString];
    NSUInteger index = [self.trackManager indexForTrack:track];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    TrackCell* cell = [self.tracksTableView cellForRowAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark - TrackListActivityDelegate

// Delegate method for getting the track list
- (void) didRecieveTracks:(NSArray *)tracks {
    // Update the searchTrackList with the recieved tracks.
    [self.trackManager addTrackList:tracks];
    
    // Reload the table with the latest track results.
    [self.tracksTableView reloadData];
    
    // Stop the network activity indicator to visible on the status bar.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //Reset the state of this variable
    self.searchButtonTapped = NO;
}

// Delegate method for error while getting the track list
- (void) didRecieveError:(NSError *)error {
    NSLog(@"Error getting song list: %@", error.description);
    
    [self.tracksTableView reloadData];
    
    // Stop the network activity indicator to visible on the status bar.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //Reset the state of this variable
    self.searchButtonTapped = NO;
    
    // Display the alert for error
    [self presentOkAlertWithTitle:@"Search Error" message:error.localizedDescription];
}

// Presents a UIAlertViewController with OK action
- (void) presentOkAlertWithTitle:(NSString *) title message:(NSString *) message {
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertViewController addAction:okAction];
    
    [self presentViewController:alertViewController animated:YES completion:nil];

}

@end
