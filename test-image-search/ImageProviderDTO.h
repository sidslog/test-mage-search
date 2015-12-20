//
//  ImageProviderDTO.h
//  test-image-search
//
//  Created by Sergey Sedov on 12/20/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

@interface ImageDTO : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *urlString;

+ (ImageDTO *) dataWithTitle: (NSString *) title width: (CGFloat) width height: (CGFloat) height urlString: (NSString *) urlString;

@end

@interface ImageProviderDTO : NSObject

@property (nonatomic, strong) NSArray *imageDTOs;
@property (nonatomic, assign) NSInteger newStartIndex;
@property (nonatomic, assign) NSInteger newTotalResults;

+ (ImageProviderDTO *) dataWithImageDTOs: (NSArray *) imageDTOs newStartIndex: (NSInteger) newStartIndex newTotalResults: (NSInteger) newTotalResults;

@end
