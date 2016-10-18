//
//  SDAppRater.h
//  SDAppRater
//
//  Created by 宋东昊 on 16/10/18.
//  Copyright © 2016年 songdh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDAppRater : NSObject
@property (nonatomic, copy) NSString *appleID;//appleID. 必填项目

@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *alertMessage;
@property (nonatomic, copy) NSString *acceptTitle;
@property (nonatomic, copy) NSString *refuseTitle;
@property (nonatomic, copy) NSString *laterTitle;

@property (nonatomic, assign) NSInteger remindDaysDelay;//当用户选择稍后提醒后，多少天再提醒一次

+(instancetype)shareInstance;
+(void)showRater;
/*
 * 第一次调用时，是否立即展示提示框。默认YES
 * 当NO时，第一次展示时间为：当前时间+remindDaysDelay；
 * 当YES时，调用showRater时立即展示
 */
+(void)showImmediately:(BOOL)flag;



@end
