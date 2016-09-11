//
//  Utilities.m
//  Utilities class which acts as the collection of utility methods.
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Pankaj Rathor. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

// Class method to provide the local path for the URL in the documents directory.
+ (NSURL *) localPathForURL:(NSURL *) fileUrl {
    
    // Get the path for the documents folder.
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    // Get the filename from the URL
    NSString *fileName = fileUrl.lastPathComponent;
    
    // Append the documents folder with file name.
    NSString *absoluteFilePath = [NSString stringWithFormat:@"%@/%@", documentPath, fileName];
    
    // Create a NSURL out of the absolute file path string.
    return [NSURL fileURLWithPath:absoluteFilePath];
}

@end
