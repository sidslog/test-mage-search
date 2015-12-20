//
//  ImagesModel.h
//  test-image-search
//
//  Created by Sergey Sedov on 12/20/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageProvider;
@protocol ImageCache;

@interface ImagesModel : NSObject

@property (readonly) NSArray *items;
@property (readonly) BOOL canLoadMoreImages;

- (instancetype) initWithImageProvider: (id<ImageProvider>) provider cache:(id<ImageCache>) cache didLoadImages: (void (^)(ImagesModel *model, NSError *error))didLoadImages;
- (void) loadNextPage;
- (void) reload;

@end
