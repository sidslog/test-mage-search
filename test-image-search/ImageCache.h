//
//  ImageCache.h
//  test-image-search
//
//  Created by Sergey Sedov on 12/20/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageProviderDTO;

@protocol ImageCache <NSObject>

// images data
- (NSArray *) allImages;
- (void) addImages: (ImageProviderDTO *) images withCompletion:(void (^)(NSError *error)) completion;

// paging data
- (NSInteger) startIndex;
- (NSInteger) totalResults;

// clear
- (void) clearCacheWithCompletion:(void (^)(NSError *error)) completion;

@end
