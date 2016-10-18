//
//  ViewController.m
//  SDAppRater
//
//  Created by 宋东昊 on 16/10/18.
//  Copyright © 2016年 songdh. All rights reserved.
//

#import "ViewController.h"
#import "SDAppRater.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"测试" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor brownColor]];
    button.frame = CGRectMake(0, 0, 150, 40);
    button.center = self.view.center;
    [self.view addSubview:button];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onClick:(id)sender
{
    [SDAppRater shareInstance].appleID = @"123456";
    /*
    [SDAppRater shareInstance].alertTitle = @"请您评价";
    [SDAppRater shareInstance].alertMessage = @"觉得不错，就赏个好评吧，我们会努力做得更好的";
    [SDAppRater shareInstance].acceptTitle = @"马上评价";
    [SDAppRater shareInstance].refuseTitle = @"残忍拒绝";
    [SDAppRater shareInstance].laterTitle = @"稍后提醒";
     */
    [SDAppRater shareInstance].remindDaysDelay = 2;
    
    [SDAppRater showRater];

}

@end
