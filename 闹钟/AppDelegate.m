//
//  AppDelegate.m
//  闹钟
//
//  Created by 王双龙 on 16/6/3.
//  Copyright © 2016年 王双龙. All rights reserved.
//

#import "AppDelegate.h"

#define kNotificationCategoryIdentifile @"kNotificationCategoryIdentifile"
#define kNotificationActionIdentifileSleep @"kNotificationActionIdentifileSleep"
#define kNotificationActionIdentifileAnswer @"kNotificationActionIdentifileAnswer"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        NSLog(@"Recieved Notification === %@",localNotification.userInfo);
    }
    
    [self registerLocalNotification];
    
    AVAudioSession * session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    return YES;
}

- (void)registerLocalNotification{
    
    //0.设置推送类型
    UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    //1.设置setting
    UIUserNotificationSettings *setting  = [UIUserNotificationSettings settingsForTypes:type categories:[NSSet setWithObject:[self category]]];
    //2.注册通知
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    
    
}

//只在前台或点击通知时执行
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification

{
    if(application.applicationState != UIApplicationStateActive){
        
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"主人，该起床了，主人，起床了，主人，起床了，主人，"];
        [self.synthesizer speakUtterance:utterance];
        
    }
}

//返回动作(按钮)的类别集合
- (UIMutableUserNotificationCategory *)category{
    
    //创建消息上面要添加的动作
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = kNotificationActionIdentifileSleep;
    action1.title = @"睡觉";
    //当点击的时候不启动程序，在后台处理
    action1.activationMode = UIUserNotificationActivationModeBackground;
    //需要解锁才能处理(意思就是如果在锁屏界面收到通知，并且用户设置了屏幕锁，用户点击了赞不会直接进入我们的回调进行处理，而是需要用户输入屏幕锁密码之后才进入我们的回调)，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action1.authenticationRequired = YES;
    /*
     destructive属性设置后，在通知栏或锁屏界面左划，按钮颜色会变为红色
     如果两个按钮均设置为YES，则均为红色（略难看）
     如果两个按钮均设置为NO，即默认值，则第一个为蓝色，第二个为浅灰色
     如果一个YES一个NO，则都显示对应的颜色，即红蓝双色 (CP色)。
     */
    action1.destructive = NO;
    
    //第二个动作
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
    action2.identifier = kNotificationActionIdentifileAnswer;
    action2.title = @"答题";
    //当点击的时候不启动程序，在后台处理
    action2.activationMode = UIUserNotificationActivationModeBackground;
    //设置了behavior属性为 UIUserNotificationActionBehaviorTextInput 的话，则用户点击了该按钮会出现输入框供用户输入
    action2.behavior = UIUserNotificationActionBehaviorTextInput;
    //这个字典定义了当用户点击了评论按钮后，输入框右侧的按钮名称，如果不设置该字典，则右侧按钮名称默认为 “发送”
    action2.parameters = @{UIUserNotificationTextInputActionButtonTitleKey: @"提交"};
    
    //创建动作(按钮)的类别集合
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    //这组动作的唯一标示
    category.identifier = kNotificationCategoryIdentifile;
    //最多支持两个，如果添加更多的话，后面的将被忽略
    [category setActions:@[action2, action1] forContext:(UIUserNotificationActionContextMinimal)];
    
    return category;
    
}

//在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler
{
    if ([identifier isEqualToString:kNotificationActionIdentifileSleep]) {
        [self showAlertView:@"你个猪，就知道睡"];
    } else if ([identifier isEqualToString:kNotificationActionIdentifileAnswer]) {
        if([responseInfo[UIUserNotificationActionResponseTypedTextKey] isEqual: notification.userInfo[@"答案"]]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"answerNoti" object:self userInfo:@{@"answer":notification.userInfo[@"答案"]}];
            
            [self showAlertView:@"恭喜你，答对了"];
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"answerNoti" object:self userInfo:@{@"answer":notification.userInfo[@"答案"]}];
            [self showAlertView:@"猪撞树上，你撞猪上了吧"];
        };
    }
    
    completionHandler();
}

- (void)showAlertView:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self.window.rootViewController showDetailViewController:alert sender:nil];
}


- (AVSpeechSynthesizer *)synthesizer
{
    if (!_synthesizer) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
    }
    return _synthesizer;
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
