//
//  CCLogViewController.m
//  CCLogSystem
//
//  Created by Chun Ye on 10/30/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import "CCLogViewController.h"
#import "CCLogController.h"
#import "CCLogSystem.h"
#import "CCLogReviewViewController.h"

static NSString *UITableViewCellReuseIdentifier = @"UITableViewCell";

@interface CCLogViewController ()

@property (nonatomic, strong) NSMutableArray *logDatas;

@end

@implementation CCLogViewController

#pragma mark - Life

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"Developer UI";
        
        self.logDatas = [NSMutableArray array];
        [self.logDatas addObjectsFromArray:[CCLogSystem availableLogs]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleCloseBarButtonitem)];
}

#pragma mark - Private

- (NSString *)logPathStringWithIndexPath:(NSIndexPath *)indexPath
{
    return [self.logDatas objectAtIndex:indexPath.row];
}

- (void)handleCloseBarButtonitem
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UITableViewCellReuseIdentifier];
    }
    NSString *logPath = [self logPathStringWithIndexPath:indexPath];
    cell.textLabel.text = [logPath lastPathComponent];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logDatas.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *logPathString = [self logPathStringWithIndexPath:indexPath];
    NSURL *logPathURL = [NSURL fileURLWithPath:logPathString];
    CCLogReviewViewController *logReviewViewController = [[CCLogReviewViewController alloc] initWithLogPathURL:logPathURL];
    [self.navigationController pushViewController:logReviewViewController animated:YES];
}

@end
