//
//  CoreDataImageCache.m
//  test-image-search
//
//  Created by Sergey Sedov on 12/20/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//

#import "CoreDataImageCache.h"
#import <MagicalRecord/MagicalRecord.h>
#import "ImageData.h"
#import "ImageProviderDTO.h"

@implementation CoreDataImageCache

+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    static CoreDataImageCache *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataImageCache alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [MagicalRecord setupAutoMigratingCoreDataStack];
    }
    return self;
}

- (NSArray *) allImages {
    return [ImageData MR_findAllSortedBy:@"orderIndex" ascending:YES];
}

- (void) addImages: (ImageProviderDTO *) imageProviderDTO withCompletion:(void (^)(NSError *error)) completion {

    __block NSInteger orderIndex = self.startIndex;
    __weak typeof(self) weakSelf = self;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {

        for (ImageDTO *item in imageProviderDTO.imageDTOs) {
            ImageData *data = [ImageData MR_createEntityInContext:localContext];
            data.orderIndex = @(orderIndex);
            data.title = item.title;
            data.urlString = item.urlString;
            data.width = @(item.width);
            data.height = @(item.height);
            orderIndex ++;
        }
        
    } completion:^(BOOL contextDidSave, NSError *MRerror) {
        if (!MRerror) {
            weakSelf.startIndex = imageProviderDTO.newStartIndex;
            weakSelf.totalResults = imageProviderDTO.newTotalResults;
        }
        completion(MRerror);
    }];
}

- (NSInteger) startIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"startIndex"];
}

- (NSInteger) totalResults {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"totalResults"];
}

- (void) setStartIndex: (NSInteger) startIndex {
    [[NSUserDefaults standardUserDefaults] setInteger:startIndex forKey:@"startIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setTotalResults: (NSInteger) totalResults {
    [[NSUserDefaults standardUserDefaults] setInteger:totalResults forKey:@"totalResults"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) clearCacheWithCompletion:(void (^)(NSError *error)) completion {
    __weak typeof(self) weakSelf = self;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [ImageData MR_truncateAllInContext:localContext];
    } completion:^(BOOL contextDidSave, NSError *MRerror) {
        if (!MRerror) {
            weakSelf.startIndex = 0;
            weakSelf.totalResults = 0;
        }
        completion(MRerror);
    }];
}

@end
