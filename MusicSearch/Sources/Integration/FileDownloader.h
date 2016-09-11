//
//  FileDownloader.h
//  MusicSearch
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Pankaj Rathor. All rights reserved.
//

#import <Foundation/Foundation.h>

// Forward declaration
@class FileDownloader;

// Protocol for providing file download updates
@protocol FileDownloaderDelegate <NSObject>

- (void) fileDownloader:(FileDownloader *) downloader didFinishDownloadingToURL:(NSURL *)location;
- (void) fileDownloader:(FileDownloader *) downloader totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;
- (void) fileDownloader:(FileDownloader *) downloader didCompleteWithError:(NSError *)error;
@end

@interface FileDownloader : NSObject

@property (weak, nonatomic) id<FileDownloaderDelegate> delegate;

- (void) downloadFileWithURL:(NSURL *) fileUrl;
@property(nonatomic,copy) NSString *fileURLString;

@end
