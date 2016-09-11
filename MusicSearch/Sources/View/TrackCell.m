//
//  TrackCell.m
//  MusicSearch
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Pankaj Rathor. All rights reserved.
//

#import "TrackCell.h"
#import "FileDownloader.h"

@interface TrackCell () <FileDownloaderDelegate> {
    BOOL paused;    // track whether the track has been paused
}

// IB Outlet for the Song Title Label
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;

// IB Outlet for the Artist Label
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;

// IB Outlet for the Artwork Image view
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

// IB Outlet for the Download Progress View
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressView;

// IB Outlet for the Download Button
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@property (strong, nonatomic) Track *trackDetails;

@end

@implementation TrackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    paused = NO;
}

- (void) setupTrackCell:(Track *) track {
    
    self.trackDetails = track;
    
    self.songTitleLabel.text = self.trackDetails.name;
    self.artistLabel.text = self.trackDetails.artist;

    __weak TrackCell *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.trackDetails.artworkURL]];
        
        UIImage *artworkImage = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.artworkImageView.image = artworkImage;
        });
        
    });
    
    self.downloadButton.hidden = !self.trackDetails.shouldDownloadFile;
}

// Handle the Download button clicked event
- (IBAction) downloadClicked:(id)sender {
    // When the download button is clicked, hide the Download button and show pause button, cancel button and download progress view.
    [self.downloadButton setHidden:YES];
    
    [self.downloadProgressView setHidden:NO];
    self.downloadProgressView.progress = 0.0;
    
    FileDownloader *previewDownloader = [[FileDownloader alloc] init];
    previewDownloader.delegate = self;
    
    [previewDownloader downloadFileWithURL:[NSURL URLWithString: self.trackDetails.previewURL]];
}

#pragma mark - FileDownloaderDelegate

- (void) fileDownloader:(FileDownloader *)downloader didFinishDownloadingToURL:(NSURL *)location {
    
    NSLog(@"File Downloaded at: %@", location.absoluteString);
    
    __weak TrackCell *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.downloadProgressView setHidden:YES];
    });
}

- (void) fileDownloader:(FileDownloader *)downloader totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    __weak TrackCell *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.downloadProgressView.progress = totalBytesWritten/totalBytesExpectedToWrite;
    });
}

- (void) fileDownloader:(FileDownloader *)downloader didCompleteWithError:(NSError *)error {
    // TODO: handle download error
}


@end
