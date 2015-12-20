//
//  GSAClient.h
//  test-image-search
//
//  Created by Sergey Sedov on 12/20/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageProvider.h"

@interface GSAClient : NSObject<ImageProvider>

+ (instancetype) sharedInstance;

@end
