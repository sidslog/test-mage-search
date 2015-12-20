//
//  ImageData.m
//  test-image-search
//
//  Created by Sergey Sedov on 12/20/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//

#import "ImageData.h"

@implementation ImageData

+ (instancetype) dataWithTitle: (NSString *) title url: (NSURL *) url width: (CGFloat) width height: (CGFloat) height {
    ImageData *data = [ImageData new];
    data.title = title;
    data.imageURL = url;
    data.width = width;
    data.height = height;
    return data;
}

@end
