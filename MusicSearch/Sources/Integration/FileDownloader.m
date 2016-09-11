//
//  FileDownloader.m
//  MusicSearch
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Pankaj Rathor. All rights reserved.
//

#import "FileDownloader.h"

NSString *backgroundSessionConfigurationIdentifier = @"fileDownloadSessionConfiguration";

@interface FileDownloader () <NSURLSessionDownloadDelegate>

// Property to hold the download Session
@property (strong, nonatomic) NSURLSession *downloadSession;

// Property to hold the download task
@property (strong, nonatomic) NSURLSessionDownloadTask *fileDownloadTask;

@end

@implementation FileDownloader

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.downloadSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    
    return self;
}

- (void) downloadFileWithURL:(NSURL *) fileUrl {
    // Create a download task for downloading the file
    self.fileURLString = fileUrl.absoluteString;
    self.fileDownloadTask = [self.downloadSession downloadTaskWithURL:fileUrl];
    
    // now start the downloading
    [self.fileDownloadTask resume];
}

- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSURL *originalUrl = downloadTask.originalRequest.URL;
    
    NSString *fileName = originalUrl.lastPathComponent;
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString *absoluteFilePath = [NSString stringWithFormat:@"%@/%@", documentPath, fileName];
    NSURL *absoluteFileUrl = [NSURL fileURLWithPath:absoluteFilePath];
    
    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    
    if ([defaultFileManager fileExistsAtPath:absoluteFilePath]) {
        NSError *fileRemoveError;
        [defaultFileManager removeItemAtPath:absoluteFilePath error:&fileRemoveError];
        
        if (fileRemoveError) {
            NSLog(@"Exiting file could not be removed: %@", fileRemoveError.description);
        }
    }
    
    NSError *copyFileError;
    [defaultFileManager copyItemAtURL:location toURL:absoluteFileUrl error:&copyFileError];
    
    if (copyFileError) {
        NSLog(@"Could not copy the file to documents directory: %@", copyFileError.description);
    }
    else {
        // Check if delegate is valid
        if (self.delegate) {
            // pass on the download finish event to the delegate
            if ([self.delegate respondsToSelector:@selector(fileDownloader:didCompleteWithError:)]) {
                __weak typeof(self) weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.delegate fileDownloader:weakSelf didFinishDownloadingToURL:absoluteFileUrl];
                });
            }
        }
    }
}

- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    // Check if delegate is valid
    if (self.delegate) {
        // pass on the download progress event to the delegate
        if ([self.delegate respondsToSelector:@selector(fileDownloader:totalBytesWritten:totalBytesExpectedToWrite:)]) {
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.delegate fileDownloader:weakSelf totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
            });
        }
    }
    
}

- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    // Check if delegate is valid
    if (self.fileDownloadTask) {
        // pass on the download error event to the delegate
        if ([self.delegate respondsToSelector:@selector(fileDownloader:didCompleteWithError:)]) {
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.delegate fileDownloader:weakSelf didCompleteWithError:error];
            });
        }
    }
}
@end
