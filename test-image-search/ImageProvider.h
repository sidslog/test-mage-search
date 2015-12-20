//
//  ImageProvider.h
//  test-image-search
//
//  Created by Sergey Sedov on 12/20/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const IMAGE_RPOVIDER_ERROR_DOMAIN = @"com.sidslog.testimagesearch.gsapi.error";
static NSInteger const IMAGE_RPOVIDER_WRONG_FORMAT_ERROR_CODE = 0;


// array of ImageData
typedef void (^ImageProviderSuccessBlock)(NSArray *resultArray, NSInteger newStartIndex, NSInteger totalResults);
typedef void (^ImageProviderErrorBlock)(NSError *error);


@protocol ImageProvider <NSObject>

- (void) loadImageDataWithStartIndex: (NSInteger) startIndex success: (ImageProviderSuccessBlock) successBlock errorBlock: (ImageProviderErrorBlock) errorBlock;

@end
