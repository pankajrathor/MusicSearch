//
//  Utilities.h
//  Utilities class which acts as the collection of utility methods.
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Pankaj Rathor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

// Class method to provide the local path for the URL in the documents directory.
+ (NSURL *) localPathForURL:(NSURL *) fileUrl;

@end
