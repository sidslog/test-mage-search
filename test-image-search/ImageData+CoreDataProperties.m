//
//  ImageData+CoreDataProperties.m
//  test-image-search
//
//  Created by Sergey Sedov on 12/20/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ImageData+CoreDataProperties.h"

@implementation ImageData (CoreDataProperties)

@dynamic title;
@dynamic width;
@dynamic height;
@dynamic urlString;
@dynamic orderIndex;

@end
