//
//  ViewController.m
//  CCLogSystemDemo
//
//  Created by Chun Ye on 10/31/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import "ViewController.h"
#import "CCLogSystem.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Open Developer UI" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openDeveloperUI) forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:button];
    
    NSMutableArray *constraits = [NSMutableArray array];
    [constraits addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [constraits addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.view addConstraints:constraits];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openDeveloperUI
{
    [CCLogSystem activeDeveloperUI];
}

@end
