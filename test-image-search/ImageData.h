//
//  ImageData.h
//  test-image-search
//
//  Created by Sergey Sedov on 12/20/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

@interface ImageData : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

+ (instancetype) dataWithTitle: (NSString *) title url: (NSURL *) url width: (CGFloat) width height: (CGFloat) height;

@end
