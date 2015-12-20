//
//  ImagesModel.m
//  test-image-search
//
//  Created by Sergey Sedov on 12/20/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//

#import "ImagesModel.h"
#import "ImageProvider.h"
#import "ImageCache.h"
#import "ImageProviderDTO.h"

@interface ImagesModel ()

@property (nonatomic, strong) id<ImageProvider> provider;
@property (nonatomic, strong) id<ImageCache> cache;
@property (nonatomic, copy) void (^didLoadImages)(ImagesModel *model, NSError *error);

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation ImagesModel

- (instancetype) initWithImageProvider: (id<ImageProvider>) provider cache:(id<ImageCache>) cache didLoadImages: (void (^)(ImagesModel *model, NSError *error))didLoadImages {
    if (self = [super init]) {
        self.provider = provider;
        self.cache = cache;
        self.didLoadImages = didLoadImages;
        self.isLoading = NO;
        _items = [self.cache allImages];
    }
    return self;
}

- (BOOL) canLoadMoreImages {
    return self.items.count < self.cache.totalResults;
}

- (void) setItems:(NSArray *)items {
    _items = items;
}

- (void) loadNextPage {
    if (self.isLoading) {
        return;
    }
    
    self.isLoading = YES;
    __weak typeof(self) weakSelf = self;
    
    [self.provider loadImageDataWithStartIndex:self.cache.startIndex withCompletion:^(ImageProviderDTO *dto, NSError *error) {
        if (weakSelf) {
            if (!error) {
                [weakSelf finishWithData:dto];
            } else {
                [weakSelf finishWithError:error];
            }
        }
    }];
}

- (void) reload {
    [self.provider cancelLoading];
    self.isLoading = NO;
    __weak typeof(self) weakSelf = self;
    [self.cache clearCacheWithCompletion:^(NSError *error) {
        if (weakSelf) {
            if (!error) {
                [weakSelf finishWithClearData];
            } else {
                [weakSelf finishWithError:error];
            }
        }
    }];
}

- (void) finishWithClearData {
    self.isLoading = NO;
    self.items = @[];
    self.didLoadImages(self, nil);
    [self loadNextPage];
}

- (void) finishWithData: (ImageProviderDTO *) imageProviderDTO {
    __weak typeof(self) weakSelf = self;
    [self.cache addImages:imageProviderDTO withCompletion:^(NSError *error) {
        if (weakSelf) {
            if (!error) {
                weakSelf.items = [weakSelf.cache allImages];
                weakSelf.isLoading = NO;
                weakSelf.didLoadImages(weakSelf, nil);
            } else {
                [weakSelf finishWithError:error];
            }
        }
    }];
}

- (void) finishWithError: (NSError *) error {
    self.isLoading = NO;
    self.didLoadImages(self, error);
}

@end
