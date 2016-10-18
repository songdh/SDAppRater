# SDAppRater
###求好评控件。采用UIAlertController来提示。因此只支持ios8以上###
项目中用到的功能，抽象了一下提取出控件。
-1. 目前不支持文本国际化。
-2. 采用`UIAlertController`来提示用户，因此最低支持版本为iOS8.0
-3. 采用`SKStoreProductViewController`来展示appStore内容
-4. 如果需要使用`UIAlertView`，可以自己在原基础上修改。

后来发现在判断时间的方法和[appirater](https://github.com/arashpayan/appirater)不谋而合。大家可以取试试。如果需要功能比较简单，可以参考我这个工程
使用方法
```
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
```

