//
//  FileHelper.m
//  Helper class which abstracts few convinient methods related to FileSystem
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper

+ (instancetype) sharedHelper {
    // Create a static instance for this class
    static FileHelper *sharedHelper = nil;
    
    // dispatch_once implmentation to ensure only one instance of this class is created.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[FileHelper alloc] init];
    });
    
    // return the static instance
    return sharedHelper;
}

- (NSFileManager*) fileManager {
    return [NSFileManager defaultManager];
}

- (NSString*) documentsDirectoryPath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

- (NSString*) localPathForURL:(NSString *)fileURLString {
    NSURL *fileURL = [NSURL URLWithString:fileURLString];
    NSString *fileName = fileURL.lastPathComponent;
    return [NSString stringWithFormat:@"%@/%@", self.documentsDirectoryPath, fileName];
}

- (BOOL) removeItemAtPath:(NSString *)path {
    NSError *error = nil;
    BOOL success = [self.fileManager removeItemAtPath:path error:&error];
    return (success && !error);
}

- (BOOL) shouldDownloadFileForURL:(NSString *)fileURLString {
    return ![[NSFileManager defaultManager] fileExistsAtPath:[self localPathForURL:fileURLString]];
}


@end
