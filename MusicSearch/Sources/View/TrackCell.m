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

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.trackDetails.artworkURL]];
        
        UIImage *artworkImage = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.artworkImageView.image = artworkImage;
        });
        
    });
    
    self.downloadButton.hidden = !self.trackDetails.shouldDownloadFile;
}

// Handle the Download button clicked event
- (IBAction)downloadClicked:(id)sender {
    if(self.downloadButtonTappedBlock) {
        self.downloadButtonTappedBlock(self);
    }
}

- (void)hideOrShowDownloadButton:(BOOL)shouldHide {
    self.downloadButton.hidden = shouldHide;
}

- (void)hideOrShowProgressView:(BOOL)shouldHide {
    self.downloadProgressView.hidden = shouldHide;
}

- (void)setProgressValue:(float)progressValue {
    self.downloadProgressView.progress = progressValue;
}

- (NSString *)previewURL {
    return self.trackDetails.previewURL;
}
@end
