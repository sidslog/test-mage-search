//
//  GoogleSearchImageProvider.m
//  test-image-search
//
//  Created by Sergey Sedov on 12/20/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//

#import "GoogleSearchImageProvider.h"
#import <AFNetworking/AFNetworking.h>
#import "ImageData.h"
#import "ImageProviderDTO.h"

static NSString *const GSAPI_BASE_URL = @"https://www.googleapis.com/customsearch/v1";
static NSString *const GSAPI_CX = @"015560692858944227391:sza_xyuzeg4";
static NSString *const GSAPI_KEY = @"AIzaSyDjKA7ftHOu86hW2xxBV_gq8-xgoWin1oY";
static NSString *const GSAPI_SEARCH_TYPE = @"image";

static NSString *const GSAPI_DEFAULT_QUERY = @"most popular images on instagram";

@interface GoogleSearchImageProvider ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation GoogleSearchImageProvider

- (instancetype) init {
    if (self = [super init]) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:GSAPI_BASE_URL]];
    }
    return self;
}

- (void) loadImageDataWithStartIndex: (NSInteger) startIndex withCompletion: (ImageProviderResultBlock) completion {
    
    // fix for google search
    if (startIndex == 0) {
        startIndex = 1;
    }
    
    NSDictionary *parameters = [self appendDefaultsParameters:@{@"start": @(startIndex)}];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionDataTask *task = [self.sessionManager GET:@"" parameters: parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *items = [weakSelf fetchItemsFromResponseObject:responseObject];
        if (items) {
            NSDictionary *nextPage = [weakSelf fetchNextPageFromResponseObject:responseObject];
            if ([nextPage[@"startIndex"] isKindOfClass:NSNumber.class] && [nextPage[@"totalResults"] isKindOfClass:NSString.class]) {
                ImageProviderDTO *dto = [ImageProviderDTO dataWithImageDTOs:items newStartIndex:[nextPage[@"startIndex"] integerValue] newTotalResults:[nextPage[@"totalResults"] integerValue]];
                completion(dto, nil);
                return;
            }
        }
        
        NSError *wrongFormatError = [NSError errorWithDomain:IMAGE_RPOVIDER_ERROR_DOMAIN code:IMAGE_RPOVIDER_WRONG_FORMAT_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: @"Invalid data format."}];
        completion(nil, wrongFormatError);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
    
    [task resume];
}

- (void) cancelLoading {
    for (NSURLSessionDataTask *task in self.sessionManager.tasks) {
        [task cancel];
    }
}

- (NSArray *) fetchItemsFromResponseObject: (NSDictionary *) responseObject {
    
    NSMutableArray *result = [@[] mutableCopy];
    
    if ([responseObject[@"items"] isKindOfClass:NSArray.class]) {
        
        for(NSDictionary *item in responseObject[@"items"]) {
            NSNumber *width = item[@"image"][@"width"];
            NSNumber *height = item[@"image"][@"height"];
            NSString *title = item[@"title"];
            NSURL *url = [NSURL URLWithString: item[@"link"]];
            if (url != nil && title != nil && width && height && [height floatValue] != 0 && [width floatValue] != 0) {
                [result addObject:[ImageDTO dataWithTitle:title width:[width floatValue] height:[height floatValue] urlString:url.absoluteString]];
            }
        }
        
        return result;
    }
    return nil;
}

- (NSDictionary *) fetchNextPageFromResponseObject: (NSDictionary *) responseObject {
    if ([responseObject[@"queries"][@"nextPage"] isKindOfClass:NSArray.class]) {
        return [responseObject[@"queries"][@"nextPage"] firstObject];
    }
    return nil;
}

- (NSDictionary *) appendDefaultsParameters: (NSDictionary *) parameters {
    NSMutableDictionary *dictionary = [parameters mutableCopy];
    dictionary[@"cx"] = GSAPI_CX;
    dictionary[@"key"] = GSAPI_KEY;
    dictionary[@"searchType"] = GSAPI_SEARCH_TYPE;
    dictionary[@"q"] = GSAPI_DEFAULT_QUERY;
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
