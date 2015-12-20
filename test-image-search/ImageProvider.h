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

@class ImageProviderDTO;

typedef void (^ImageProviderResultBlock)(ImageProviderDTO *dto, NSError *error);

@protocol ImageProvider <NSObject>

- (void) loadImageDataWithStartIndex: (NSInteger) startIndex withCompletion: (ImageProviderResultBlock) completion;
- (void) cancelLoading;

@end
