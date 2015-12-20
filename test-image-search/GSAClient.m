//
//  GSAClient.m
//  test-image-search
//
//  Created by Sergey Sedov on 12/20/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//

#import "GSAClient.h"
#import <AFNetworking/AFNetworking.h>
#import "ImageData.h"

static NSString *const GSAPI_BASE_URL = @"https://www.googleapis.com/customsearch/v1";
static NSString *const GSAPI_CX = @"015560692858944227391:sza_xyuzeg4";
static NSString *const GSAPI_KEY = @"AIzaSyDjKA7ftHOu86hW2xxBV_gq8-xgoWin1oY";
static NSString *const GSAPI_SEARCH_TYPE = @"image";

static NSString *const GSAPI_DEFAULT_QUERY = @"most popular images on instagram";

@interface GSAClient ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation GSAClient

+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    static GSAClient *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[GSAClient alloc] init];
    });
    return instance;
}

- (instancetype) init {
    if (self = [super init]) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:GSAPI_BASE_URL]];
    }
    return self;
}

- (void)loadImageDataWithStartIndex:(NSInteger)startIndex success:(ImageProviderSuccessBlock)successBlock errorBlock:(ImageProviderErrorBlock)errorBlock {
    
    NSDictionary *parameters = [self appendDefaultsParameters:@{@"start": @(startIndex)}];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionDataTask *task = [self.sessionManager GET:@"" parameters: parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *items = [weakSelf fetchItemsFromResponseObject:responseObject];
        if (items) {
            NSDictionary *nextPage = [weakSelf fetchNextPageFromResponseObject:responseObject];
            if ([nextPage[@"startIndex"] isKindOfClass:NSNumber.class] && [nextPage[@"totalResults"] isKindOfClass:NSString.class]) {
                successBlock(items, [nextPage[@"startIndex"] integerValue], [nextPage[@"totalResults"] integerValue]);
                return;
            }
        }
        
        NSError *wrongFormatError = [NSError errorWithDomain:IMAGE_RPOVIDER_ERROR_DOMAIN code:IMAGE_RPOVIDER_WRONG_FORMAT_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: @"Invalid data format."}];
        errorBlock(wrongFormatError);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
    
    [task resume];
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
                ImageData *data = [ImageData dataWithTitle:title url:url width:[width floatValue] height:[height floatValue]];
                [result addObject:data];
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
