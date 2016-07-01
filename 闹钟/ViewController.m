//
//  ViewController.m
//  闹钟
//
//  Created by 王双龙 on 16/6/3.
//  Copyright © 2016年 王双龙. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "PinTuViewController.h"
#define kNotificationCategoryIdentifile @"kNotificationCategoryIdentifile"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker        *datePicker;
@property (strong, nonatomic) IBOutlet UILabel             *presentTime;
@property (strong, nonatomic) IBOutlet UILabel             *timeLabel;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonnull,strong   ) NSString            * answer;

@property (nonatomic,assign ) BOOL                isTouch;
@property (weak, nonatomic  ) IBOutlet UILabel             *answerLabel;
@property (weak, nonatomic  ) IBOutlet UIImageView         *imageView;
@end

@implementation ViewController
-  (AVSpeechSynthesizer *)synthesizer
{
    if (!_synthesizer) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
    }
    return _synthesizer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(answerNoti:) name:@"answerNoti" object:nil];
    
    //当前时间
    NSDate *now = [NSDate date];
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags  = NSCalendarUnitYear |  NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute ;
    
    NSDateComponents *dd = [calendar components:unitFlags fromDate:now];
    
    NSInteger y = [dd year];
    NSInteger m = [dd month];
    NSInteger d = [dd day];
    NSInteger hour = [dd hour];
    NSInteger min = [dd minute];
    
   // self.presentTime.text = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",y,m,d,hour,min];
    self.timeLabel.text = @"时间";
    self.datePicker.date = now;
}

- (void)answerNoti:(NSNotification *)noti{
    
    self.answerLabel.text = noti.userInfo[@"answer"];
    self.imageView.image  = [UIImage imageNamed:@"1.png"];
    
}
- (IBAction)tap:(id)sender {
    
    PinTuViewController * pinTuVC = [[PinTuViewController alloc] init];
    [self presentViewController:pinTuVC animated:YES completion:nil];
}

//添加按钮
- (IBAction)sure:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //时区
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    NSString *dateTimeString = [dateFormatter stringFromDate:self.datePicker.date];
    self.timeLabel.text = dateTimeString;
    
    // 点击确定 设置好时间之后添加本地提醒  用UILocalNotification来实现。
    [self scheduleLocalNotificationWithDate:self.datePicker.date];
    [self remindController:@"闹钟添加好了"];
    
    [self voiceAnnouncementsText:@"主人，闹钟已经给你添加好了，还有什么吩咐"];
}
//取消按钮
- (IBAction)cencal:(id)sender {
    //取消所有的本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self remindController:@"闹钟提醒已经取消"];
    
    [self voiceAnnouncementsText:@"主人，闹钟提醒已经取消"];
}
//通知
- (void)scheduleLocalNotificationWithDate:(NSDate *)fireDate
{
    //1.创建推送通知
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //2.设置推送时间
    [localNotification setFireDate:fireDate];
    //3.设置时区
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //4.推送内容
    [localNotification setAlertBody:[NSString stringWithFormat:@"觉醒吧 Super Man 地球等着你去拯救啊！来，先热个身，脑筋急转个弯 问：%@,",[self question]]];
    localNotification.userInfo = @{@"答案": self.answer};
    
    //5.推送声音
    
    //默认声音
    //localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    localNotification.soundName = @"Coming Home.m4r";
    
    //[_localNotification setSoundName:[[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Main.bundle"]stringByAppendingPathComponent:@"bayinhe.caf"]];
    //通知动作组类型的唯一标示
    localNotification.category = kNotificationCategoryIdentifile;
    
    //6.添加推送到UIApplication
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}
//返回plist里的问题
- (NSString *)question{
    
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"question" ofType:@"plist"];
    NSDictionary * dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray * arry = [dict allKeys];
    
    int i = arc4random()%(dict.count);
    NSLog(@"%@",arry[i]);
    
    self.answer = dict[arry[i]];
    
    return arry[i];
}
//提示页面
- (void)remindController:(NSString *)remindText
{
    //提示页面（8.0出现）
    /**
     * 1.创建UIAlertController的对象
     2.创建UIAlertController的方法
     3.控制器添加action
     4.用presentViewController模态视图控制器
     */
    UIAlertController *alart = [UIAlertController alertControllerWithTitle:@"提示" message:remindText preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alart animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alart dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}
//语音播报
- (void)voiceAnnouncementsText:(NSString *)text
{
    AVSpeechUtterance * utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    [self.synthesizer speakUtterance:utterance];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 获取手指
    UITouch *touch = [touches anyObject];
    
    // 判断手指是否在触摸
    if (touch.view == self.imageView) {
        self.isTouch = YES;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isTouch) {
        // 开启上下文
        UIGraphicsBeginImageContext(self.imageView.bounds.size);
        // 将图片绘制到图形上下文中
        [self.imageView.image drawInRect:self.imageView.bounds];
        // 清空手指触摸的位置
        // 拿到手指,根据手指的位置,让对应的位置成为透明
        UITouch * touch      = [touches anyObject];
        CGPoint point        = [touch locationInView:touch.view];
        CGRect rect          = CGRectMake(point.x - 10, point.y - 10, 5 ,5);
        // 清空rect范围的部分
        CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
        // 取出之后的图片赋值给imageView
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭图形上下文
        UIGraphicsEndImageContext();
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.isTouch = NO;
}

@end
