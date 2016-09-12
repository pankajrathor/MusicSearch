//
//  TrackCell.h
//  MusicSearch
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"

@class TrackCell;

typedef void (^TrackCellDownloadButtonTappedBlock) (TrackCell *cell);

@interface TrackCell : UITableViewCell

@property(nonatomic,strong) TrackCellDownloadButtonTappedBlock downloadButtonTappedBlock;

// Sets up the cell as per the track information
- (void) setupTrackCell:(Track *) track;

// Shows/hides the download button
- (void) hideDownloadButton:(BOOL)shouldHide;

// Shows/hides the progress view
- (void) hideProgressView:(BOOL)shouldHide;

// Set the value for the progress view
- (void) setProgressValue:(float)progressValue;

// Preview URL for the track
- (NSString *) previewURL;

@end
