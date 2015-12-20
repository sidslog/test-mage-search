//
//  ViewController.m
//  test-image-search
//
//  Created by Sergey Sedov on 12/19/15.
//  Copyright © 2015 Sergey Sedov. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GSAClient.h"
#import "ImageTableViewCell.h"
#import "ImagesModel.h"
#import "ImageData.h"

@interface ViewController ()

@property (nonatomic, strong) ImagesModel *model;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 416;

    __weak typeof(self) weakSelf = self;
    self.model = [[ImagesModel alloc] initWithImageProvider:[GSAClient sharedInstance] didLoadImages:^(ImagesModel *model, NSError *error) {
        if (weakSelf) {
            if (!error) {
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf showError:error];
            }
        }
    }];
    [self.model loadNextPage];
}

#pragma mark - table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.items.count + (self.model.canLoadMoreImages ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *items = self.model.items;
    if (indexPath.row < items.count) {
        ImageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
        [self configureImageCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        UITableViewCell *loadingCell = [self.tableView dequeueReusableCellWithIdentifier:@"LoadingCell" forIndexPath:indexPath];
        return loadingCell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.model.items.count) {
        [self.model loadNextPage];
    }
}

- (void) configureImageCell: (ImageTableViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    ImageData *data = self.model.items[indexPath.row];
    [cell.pictureView sd_setImageWithURL: data.imageURL];
    cell.titleView.text = data.title;
    cell.heightConstraint.constant = ceilf(self.tableView.bounds.size.width * data.height / data.width);
    [cell layoutIfNeeded];
}

#pragma mark - error handling

- (void) showError: (NSError *) error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}

@end
