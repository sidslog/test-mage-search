//
//  ImageData+CoreDataProperties.h
//  test-image-search
//
//  Created by Sergey Sedov on 12/20/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ImageData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *width;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) NSString *urlString;
@property (nullable, nonatomic, retain) NSNumber *orderIndex;

@end

NS_ASSUME_NONNULL_END
