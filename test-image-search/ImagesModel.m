//
//  ImagesModel.m
//  test-image-search
//
//  Created by Sergey Sedov on 12/20/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//

#import "ImagesModel.h"
#import "ImageProvider.h"

@interface ImagesModel ()

@property (nonatomic, strong) id<ImageProvider> provider;
@property (nonatomic, copy) void (^didLoadImages)(ImagesModel *model, NSError *error);

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger totalResuts;

@end

@implementation ImagesModel

- (instancetype) initWithImageProvider: (id<ImageProvider>) provider didLoadImages: (void (^)(ImagesModel *model, NSError *error))didLoadImages {
    if (self = [super init]) {
        self.provider = provider;
        self.didLoadImages = didLoadImages;
        self.isLoading = NO;
        self.startIndex = 1;
        _items = @[];
    }
    return self;
}

- (BOOL) canLoadMoreImages {
    return self.items.count < self.totalResuts;
}

- (void) loadNextPage {
    if (self.isLoading) {
        return;
    }
    
    self.isLoading = YES;
    __weak typeof(self) weakSelf = self;
    
    [self.provider loadImageDataWithStartIndex:self.startIndex success:^(NSArray *resultArray, NSInteger newStartIndex, NSInteger totalResults) {
        if (weakSelf) {
            [weakSelf finishWithData:resultArray newStartIndex:newStartIndex newTotalResults:totalResults];
        }
    } errorBlock:^(NSError *error) {
        if (weakSelf) {
            [weakSelf finishWithError:error];
        }
    }];
    
}

- (void) finishWithData: (NSArray *) newItems newStartIndex: (NSInteger) newStartIndex newTotalResults: (NSInteger) newTotalResults {
    self.startIndex = newStartIndex;
    self.totalResuts = newTotalResults;
    _items = [self.items arrayByAddingObjectsFromArray:newItems];
    self.isLoading = NO;
    self.didLoadImages(self, nil);
}

- (void) finishWithError: (NSError *) error {
    self.isLoading = NO;
    self.didLoadImages(self, error);
}

@end
