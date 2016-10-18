//
//  SDAppRater.m
//  SDAppRater
//
//  Created by 宋东昊 on 16/10/18.
//  Copyright © 2016年 songdh. All rights reserved.
//

#import "SDAppRater.h"
#import <StoreKit/StoreKit.h>

static NSString *const SDAppRaterNextRateDate = @"SDAppRaterNextRateDate";
static NSString *const SDAppRaterCurrentVersion = @"SDAppRaterCurrentVersion";

@interface SDAppRater ()<SKStoreProductViewControllerDelegate>

@end

@implementation SDAppRater

+(instancetype)shareInstance
{
    static SDAppRater *appRater;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appRater = [[SDAppRater alloc]init];
    });
    return appRater;
}

-(instancetype)init
{
    if (self = [super init]) {
        
        _alertTitle = @"请您评价";
        
        _alertMessage = @"觉得不错，就赏个好评吧，我们会努力做得更好的";
        
        _acceptTitle = @"马上评价";
        
        _refuseTitle = @"残忍拒绝";
        
        _laterTitle = @"稍后提醒";
        
        _remindDaysDelay = 7;//默认七天提醒
        
    }
    return self;
}

+(void)showImmediately:(BOOL)flag
{
    if (!flag && [[NSUserDefaults standardUserDefaults] integerForKey:SDAppRaterNextRateDate] <= 0) {
        //设置下次提醒的时间
        NSTimeInterval currentDate = [[NSDate date] timeIntervalSince1970];
        [[NSUserDefaults standardUserDefaults] setDouble:currentDate+[SDAppRater shareInstance].remindDaysDelay*24*60*60
                                                  forKey:SDAppRaterNextRateDate];
    }
}

+(void)showRater
{
    NSAssert([SDAppRater shareInstance].appleID, @"appleID不能为空");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    //判断版本，新版本时重置时间标识。重新提醒用户
    NSString *oldVersion = [userDefaults stringForKey:SDAppRaterCurrentVersion];
    NSString *newVersion = [self appVersion];
    
    if ([newVersion compare:oldVersion options:NSNumericSearch] == NSOrderedAscending) {
        //可以更新,记录新的版本号，同时删除下次更新的时间标识
        [userDefaults setObject:newVersion forKey:SDAppRaterCurrentVersion];
        [userDefaults removeObjectForKey:SDAppRaterNextRateDate];
        [userDefaults synchronize];
    }
    
    NSTimeInterval currentDate = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval nextRateDate = [userDefaults doubleForKey:SDAppRaterNextRateDate];
    
    //选择稍后更新
    if (nextRateDate - currentDate <= 0) {
        //showalert
        [self showAlertController];
    }
    
}

#pragma mark - Tools
+ (NSString *)appVersion
{
    NSString * value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if ( nil == value || 0 == value.length ) {
        value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    return value;
}

+(void)showAlertController
{
    SDAppRater *shareInstance = [SDAppRater shareInstance];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:shareInstance.alertTitle message:shareInstance.alertMessage  preferredStyle:UIAlertControllerStyleAlert];
    
    //取评价
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:shareInstance.acceptTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转appstore
        
        
        SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
        
        [storeViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@(shareInstance.appleID.integerValue)} completionBlock:nil];
        storeViewController.delegate = shareInstance;
        [self showController:storeViewController];
        
        //已经评价过，以后也不再展示
        [[NSUserDefaults standardUserDefaults] setDouble:MAXFLOAT forKey:SDAppRaterNextRateDate];
        
    }];
    [alertController addAction:acceptAction];
    
    //拒绝
    UIAlertAction *refuseAction = [UIAlertAction actionWithTitle:shareInstance.refuseTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //拒绝评价,将时间标识设置为最大值
        [[NSUserDefaults standardUserDefaults] setDouble:MAXFLOAT forKey:SDAppRaterNextRateDate];
    }];
    [alertController addAction:refuseAction];
    
    //稍后提醒
    UIAlertAction *laterAction = [UIAlertAction actionWithTitle:shareInstance.laterTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ;
        //设置下次提醒的时间
        NSTimeInterval currentDate = [[NSDate date] timeIntervalSince1970];
        [[NSUserDefaults standardUserDefaults] setDouble:currentDate+shareInstance.remindDaysDelay*24*60*60
                                                  forKey:SDAppRaterNextRateDate];
        
    }];
    [alertController addAction:laterAction];
    
    [self showController:alertController];
}


+(void)showController:(UIViewController*)viewController
{
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *presentedViewController = rootController.presentedViewController;
    if (presentedViewController) {
        [presentedViewController presentViewController:viewController animated:YES completion:nil];
    }else{
        [rootController presentViewController:viewController animated:YES completion:nil];
    }
}



#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


@end
