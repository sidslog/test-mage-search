//
//  ImageProviderDTO.m
//  test-image-search
//
//  Created by Sergey Sedov on 12/20/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//

#import "ImageProviderDTO.h"

@implementation ImageDTO

+ (ImageDTO *) dataWithTitle: (NSString *) title width: (CGFloat) width height: (CGFloat) height urlString: (NSString *) urlString {
    ImageDTO *data = [ImageDTO new];
    data.title = title;
    data.width = width;
    data.height = height;
    data.urlString = urlString;
    return data;
}

@end

@implementation ImageProviderDTO

+ (ImageProviderDTO *) dataWithImageDTOs: (NSArray *) imageDTOs newStartIndex: (NSInteger) newStartIndex newTotalResults: (NSInteger) newTotalResults {
    ImageProviderDTO *data = [ImageProviderDTO new];
    data.imageDTOs = imageDTOs;
    data.newStartIndex = newStartIndex;
    data.newTotalResults = newTotalResults;
    return data;
}


@end
