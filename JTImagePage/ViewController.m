//
//  ViewController.m
//  JTImagePage
//
//  Created by CC on 15/5/19.
//  Copyright (c) 2015年 John TSai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    __block JTImagePage *imagePage = [[JTImagePage alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
    imagePage.dataSource = ^(JTImagePage *imagePage) {
        return @[[UIImage imageNamed:@"dog0.jpg"], [UIImage imageNamed:@"dog1.jpg"], [UIImage imageNamed:@"dog2.jpg"],
                 [UIImage imageNamed:@"dog3.jpg"], [UIImage imageNamed:@"dog4.jpg"], [UIImage imageNamed:@"dog5.jpg"],
                 [UIImage imageNamed:@"dog6.jpg"], [UIImage imageNamed:@"dog7.jpg"]];
    };
    
    imagePage.pageDelegate = ^(NSUInteger index) {
        NSLog(@"%li",index);
    };
    [self.view addSubview:imagePage];
    
    [imagePage reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
